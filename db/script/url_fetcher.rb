module UrlFetcher
  def self.keyword_register!
    KeywordRegisterService.multi_register_by_urls!(urls)
  end
end