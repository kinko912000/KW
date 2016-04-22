class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :count_keywords

  def count_keywords
    @total_count = Kw::Word.enable.count
    @query_keywords_count = Kw::Word.has_query_volumes.enable.count
    @orchid_keywords_count = Kw::Word.has_query_volumes.enable.search(name_cont: "胡蝶蘭").result.count
    @selected_query_volumes_count = Kw::Word.has_query_volumes.selected.enable.count
  end
end
