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

    @words = @words.order(updated_at: :desc, avg_searches: :desc).page(params[:page]).per(30)
    @count = Kw::Word.where.not(avg_searches: nil).count
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
    KeywordRegisterService.delay.multi_register!(parse_urls)
    redirect_to words_path
  end

  def parse_urls
    return [] unless params[:urls].present?
    params[:urls].split(/\n/)
  end
end
