require 'optparse'
module UrlFetcher
  def self.keyword_register!(word, options)
    (1..10).to_a.each do |page|
      urls = KeywordRegisterService.fetch_urls_by_word(word, {page: page}.merge(options))
      KeywordRegisterService.multi_register_by_urls!(urls)
      sleep(5)
    end
  end
end

options = {}
banner = "Usage: rails runner db/script/url_fetcher [options]"

OptionParser.new do |opts|
  opts.banner = banner
  opts.on("-n", "--news", "search by news") { |news| options[:news] = news }
  opts.parse!(ARGV)
end

Kw::Word.has_query_volumes.selected.map(&:name).each do |word|
  UrlFetcher.keyword_register!(word, options)
end