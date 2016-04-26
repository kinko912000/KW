require 'google/spread_sheet'

module WrittingFetcher
  BOOK_ID = '1K2Nj1Pfgka0Spx3X8insKwB85QhJOvmVRzwRRq63hGk'
  SHEET_NAME = '管理シート'
  MAX_KEYWORD_NUMS = 1000

  def self.fetch

    @client = Google::SpreadSheet.new(BOOK_ID)
    @client.set_sheet_by_title(SHEET_NAME)

    (1..MAX_KEYWORD_NUMS).to_a.each do |index|
      keyword = @client.sheet[index + 3, 1]
      article_url = "https://hitohana.tokyo/note/#{@client.sheet[index + 3, 4].slice(/\d+/)}" if url?(@client.sheet[index + 3, 4])

      word = Kw::Word.find_by(name: keyword)

      unless word.present?
        puts "#{keyword}: キーワードが見つかりませんでした"
        next 
      end

      if url?(article_url) && word.update_attributes(article_url: article_url)
        puts "#{keyword} の更新に成功しました。 #{article_url}"
      else
        puts "#{keyword} の更新に失敗しました"
      end
    end
  end

  def self.url?(url)
    return false unless url.present?
    url.include?("http")
  end
end
WrittingFetcher.fetch
