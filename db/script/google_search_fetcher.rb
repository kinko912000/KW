require 'open-uri'
module GoogleSearchFetcher
  def self.update(word)
    urls = KeywordRegisterService.fetch_urls_by_word(word.name)
    search_url_params = {primary_url: urls.first, second_url: urls.second}
    puts "could not save: #{word.name}" unless word.update_attributes(search_url_params)
  end
end

Kw::Word.where(primary_url: nil).has_query_volumes.find_each do |word|
  GoogleSearchFetcher.update(word)
  sleep(5)
end