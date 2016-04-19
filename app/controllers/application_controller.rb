class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :count_keywords

  def count_keywords
    @count = Kw::Word.has_query_volumes.enable.count
  end
end
