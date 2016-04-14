require 'open-uri'
module KeywordRegisterService
  API_URL = 'http://so-zou.jp/web-app/text/morpheme/analyze.php'

  def self.multi_register!(urls)
    urls.each { |url| self.delay.register!(url) }
  end

  def self.register!(url)
    begin
      doc = Nokogiri::HTML(open(url))
      body = doc.xpath('//text()').map { |n| n.content }.join(' ').force_encoding('UTF-8').scrub('?').gsub(/\p{WSpace}+/,' ')
      body.scan(/.{1,10000}/).each do |text|
        res = Net::HTTP.post_form(URI.parse(API_URL), {text: text})

        strs = JSON.parse(res.body).map { |data| data["baseform"] if data["pos"] == "名詞" }.compact.uniq
        strs = strs.reject { |a| a =~ /\w+/ }
        strs = strs.map { |str| "胡蝶蘭 #{str}" }

        words = (strs - Kw::Word.where(name: strs).pluck(:name)).map { |name| Kw::Word.new(name: name) }
        Kw::Word.import words
      end
    rescue => e
      puts e
    end
  end
end
