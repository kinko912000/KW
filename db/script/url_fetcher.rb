module UrlFetcher
  def self.keyword_register!(word)
    (1..10).to_a.each do |page|
      urls = KeywordRegisterService.fetch_urls_by_word(word, {page: page})
      KeywordRegisterService.multi_register_by_urls!(urls)
      sleep(2)
    end
  end
end

Kw::Word.has_query_volumes.selected.map(&:name).each do |word|
  UrlFetcher.keyword_register!(word)
end