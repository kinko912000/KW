require 'open-uri'
module KeywordRegisterService
  API_URL = 'http://so-zou.jp/web-app/text/morpheme/analyze.php'

  def self.multi_register_by_urls!(urls)
    urls.each do |url|
      words = fetch_words_by_url(url)
      self.delay.register!(words)
    end
  end

  def self.register!(words, options = {})
    ActiveRecord::Base.transaction do
      target_words = format_words(words).uniq
      Kw::Word.import filter_words(target_words)
      Kw::Word.where(name: target_words).update_all(selected: true) if options[:selected]
    end
  end

  def self.fetch_words_by_url(url)
    begin
      doc = Nokogiri::HTML(open(url))
      body = doc.xpath('//text()').map { |n| n.content }.join(' ').force_encoding('UTF-8').scrub('?').gsub(/\p{WSpace}+/,' ')
      words = []
      body.scan(/.{1,10000}/).each do |text|
        res = Net::HTTP.post_form(URI.parse(API_URL), {text: text})

        strs = JSON.parse(res.body).map { |data| data["baseform"] if data["pos"] == "名詞" }.compact.uniq
        strs = strs.reject { |a| a =~ /\w+/ }
        words << strs.map { |str| "胡蝶蘭 #{str}" }
      end
      words.flatten
    rescue => e
      puts e
      nil
    end
  end

  def self.filter_words(words)
    unregistered_words = words - Kw::Word.where(name: words).pluck(:name)
    unregistered_words.map { |name| Kw::Word.new(name: name) }
  end

  def self.format_words(words)
    words.map { |word| word.gsub(/(\s|　)+/, ' ') }
  end
end
