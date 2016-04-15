require 'open-uri'
module GoogleSearchFetcher
  def self.update(word)
    url = generate_search_url(word.name)
    primary_url = fetch_primary_url(url)
    word.primary_url = primary_url
    puts "could not save: #{word.name}" unless word.save
  end


  def self.fetch_primary_url(url)
    open(URI.encode(url)) do |res|
      begin
        doc = Nokogiri::HTML(res)
        primary_url = nil
        doc.css('.g h3 a').each do |dom|
          link = dom.attribute('href').value.scan(/http.*/).first
          if link.present?
            primary_url = link.gsub(/&sa.*/, '')
            puts "url: #{url}, primary_url: #{primary_url}"
            break
          else
            puts "nothing: #{dom.attribute('href').value}"
          end
        end
        primary_url
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
  sleep(2)
end