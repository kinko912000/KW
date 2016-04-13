class WordsController < ApplicationController
  def index

  end

  def register
    ### NOTE: mecab は細かく単語を区切るのでキーワードを採掘しにくい
    ###       http://so-zou.jp/web-app/text/morpheme/ で採掘する
    api_url = 'http://so-zou.jp/web-app/text/morpheme/analyze.php'

    doc = Nokogiri::HTML(open("http://www.kochoran.ne.jp/"))
    body = doc.xpath('//text()').map { |n| n.content }.join('').gsub(/\p{WSpace}+/,' ')
    res = Net::HTTP.post_form(URI.parse(api_url), {text: body})

    strs = JSON.parse(res.body).map { |data| data["baseform"] if data["pos"] == "名詞" }.compact.uniq
    strs = strs.reject { |a| a =~ /\w+/ }
  end
end
