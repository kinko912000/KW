require 'csv'

module AdwordsIndicator
  def self.exec
    path = Rails.root.join('tmp/google_adowrds_api/*')
    Dir.glob(path).each do |f|
      open(f, "rb:BOM|UTF-16:UTF-8") do |csv_file|
        CSV.new(csv_file, headers: :first_row, col_sep: "\t").each do |row|
          row.each { |k, v| v.gsub!(/(\r\n|\r)/, "\n") unless v.nil? }
          word_params = parse_word_params(row)
          word = Kw::Word.find_by(name: word_params[:name])
          if word_params[:name].present? && word.present?
            word.update_attributes(word_params)
          end
        end
      end
    end
  end

  def self.parse_word_params(row)
    word_params = {
      name: row["Keyword"],
      avg_searches: row["Avg. Monthly Searches (exact match only)"],
      suggested_bid: row["Suggested bid"],
      competition: row["Competition"],
    }
    word_params[:fetched] = true
    word_params
  end
end

AdwordsIndicator.exec