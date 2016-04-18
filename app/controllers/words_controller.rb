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

    @words = @words.order(avg_searches: :desc, updated_at: :desc).page(params[:page]).per(30)
    @same_primary_url_list = Kw::Word.where(primary_url: @words.map(&:primary_url)).
      group_by { |word| word.primary_url }
    @same_second_url_list = Kw::Word.where(second_url: @words.map(&:second_url)).
      group_by { |word| word.second_url }
  end

  def download
    csv_data = CSV.generate do |csv|
      Kw::Word.unfetched.limit(1000).each do |word|
        csv << [word.name]
      end
    end

    send_data csv_data, filename: "keywords_#{Time.current}"
  end

  def new
  end

  def create
    options = {}
    options = {selected: true} if params[:selected].to_b
    KeywordRegisterService.register!(parse_words, options)
    redirect_to words_path
  end


  def new_by_urls
  end

  def register_by_urls
    ### NOTE: mecab は細かく単語を区切るのでキーワードを採掘しにくい
    ###       http://so-zou.jp/web-app/text/morpheme/ で採掘する
    KeywordRegisterService.delay.multi_register_by_urls!(parse_urls)
    redirect_to words_path
  end

  private

  def parse_urls
    return [] unless params[:urls].present?
    params[:urls].split(/\r\n|\n/)
  end

  def parse_words
    return [] unless params[:words].present?
    params[:words].split(/\r\n|\n/)
  end
end
