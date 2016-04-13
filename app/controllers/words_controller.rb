require 'open-uri'
class WordsController < ApplicationController
  def index

  end

  def register
    ### NOTE: mecab は細かく単語を区切るのでキーワードを採掘しにくい
    ###       http://so-zou.jp/web-app/text/morpheme/ で採掘する

    ### TODO: エラー処理
    api_url = 'http://so-zou.jp/web-app/text/morpheme/analyze.php'

    doc = Nokogiri::HTML(open(params[:url]))
    body = doc.xpath('//text()').map { |n| n.content }.join('').gsub(/\p{WSpace}+/,' ')
    res = Net::HTTP.post_form(URI.parse(api_url), {text: body})

    strs = JSON.parse(res.body).map { |data| data["baseform"] if data["pos"] == "名詞" }.compact.uniq
    strs = strs.reject { |a| a =~ /\w+/ }

    words = (strs - Kw::Word.where(name: strs).pluck(:name)).map { |name| Kw::Word.new(name: name) }
    Kw::Word.import words

    redirect_to words_path
  end
end
