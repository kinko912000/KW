require 'open-uri'
module KeywordRegisterService
  API_URL = 'http://so-zou.jp/web-app/text/morpheme/analyze.php'

  def self.multi_register!(urls)
    urls.each { |url| self.delay.register!(url) }
  end

  def self.register!(url)
    doc = Nokogiri::HTML(open(url))
    body = doc.xpath('//text()').map { |n| n.content }.join('').gsub(/\p{WSpace}+/,' ')
    res = Net::HTTP.post_form(URI.parse(API_URL), {text: body})

    strs = JSON.parse(res.body).map { |data| data["baseform"] if data["pos"] == "名詞" }.compact.uniq
    strs = strs.reject { |a| a =~ /\w+/ }
    strs = strs.map { |str| "胡蝶蘭 #{str}" }

    words = (strs - Kw::Word.where(name: strs).pluck(:name)).map { |name| Kw::Word.new(name: name) }
    Kw::Word.import words
  end
end
