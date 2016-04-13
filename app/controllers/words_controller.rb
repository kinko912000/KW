require 'open-uri'
require 'csv'

class WordsController < ApplicationController
  def index
    ### TODO: searcher に切り出し
    @words = Kw::Word.all

    if params[:fetched].present?
      if params[:fetched] == 'false'
        @words = Kw::Word.unfetched
      else
        @words = Kw::Word.fetched
      end
    end

    if params[:selected].present?
      if params[:selected] == 'false'
        @words = @words.unselected
      else
        @words = @words.selected
      end
    end

    @words = @words.page(params[:page]).per(30)
  end

  def download
    csv_data = CSV.generate do |csv|
      Kw::Word.unfetched.limit(1000).each do |word|
        csv << [word.name]
      end
    end

    send_data csv_data, filename: "keywords_#{Time.current}"
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
    strs = strs.map { |str| "胡蝶蘭 #{str}" }

    words = (strs - Kw::Word.where(name: strs).pluck(:name)).map { |name| Kw::Word.new(name: name) }
    Kw::Word.import words

    redirect_to words_path
  end
end
