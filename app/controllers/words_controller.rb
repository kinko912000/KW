require 'open-uri'
require 'csv'

class WordsController < ApplicationController
  def index
    @words = WordSearchService::Searcher.new(parse_search_params).result
    @words = @words.page(params[:page]).per(30)
    @same_primary_url_count = Kw::Word.where(primary_url: @words.map(&:primary_url)).
      where.not(primary_url: nil).group(:primary_url).count.
      each_with_object({}) { |(url, count), result| result[url] = count - 1 }
    @same_second_url_count = Kw::Word.where(second_url: @words.map(&:second_url)).
      where.not(second_url: nil).group(:second_url).count.
      each_with_object({}) { |(url, count), result| result[url] = count - 1 }
  end

  def show
    @word = Kw::Word.find(params[:id])

    @same_primary_url_list = Kw::Word.where(primary_url: @word.primary_url).
      where.not(primary_url: nil).group_by(&:name)
    @same_second_url_list = Kw::Word.where(second_url: @word.second_url).
      where.not(second_url: nil).group_by(&:name)
    @words = [@word].concat(@same_primary_url_list.values.concat(@same_second_url_list.values)).flatten.uniq
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

  def parse_search_params
    attrs = [:fetched, :selected, :name, :sort_key]
    params.slice(*attrs)
  end
  def parse_urls
    return [] unless params[:urls].present?
    params[:urls].split(/\r\n|\n/)
  end

  def parse_words
    return [] unless params[:words].present?
    params[:words].split(/\r\n|\n/)
  end
end
