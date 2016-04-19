require 'open-uri'
module GoogleSearchFetcher
  def self.update(word)
    url = generate_search_url(word.name)
    search_url_params = fetch_url_params(url)
    puts "could not save: #{word.name}" unless word.update_attributes(search_url_params)
  end


  def self.fetch_url_params(url)
    open(URI.encode(url)) do |res|
      begin
        doc = Nokogiri::HTML(res)
        result = {primary_url: nil, second_url: nil}
        doc.css('.g h3 a').each do |dom|
          link = dom.attribute('href').value.scan(/http.*/).first
          next puts "nothing: #{dom.attribute('href').value}" unless link.present?

          link = link.gsub(/&sa.*/, '')
          if result[:primary_url].blank?
            puts "url: #{url}, primary_url: #{link}"
            result[:primary_url] = link
            next
          end

          if result[:second_url].blank?
            puts "url: #{url}, second_url: #{link}"
            result[:second_url] = link
            break
          end
        end
        result
      rescue => e
        puts "############# ERROR ##############"
        puts "Error URL: #{url}"
        puts e
        nil
      end
    end
  end

  def self.generate_search_url(keyword)
    base_uri = "https://www.google.co.jp/search?q="
    "#{base_uri}#{keyword}"
  end
end

#Kw::Word.find_each do |word|
Kw::Word.where(primary_url: nil).has_query_volumes.find_each do |word|
  GoogleSearchFetcher.update(word)
  sleep(5)
end