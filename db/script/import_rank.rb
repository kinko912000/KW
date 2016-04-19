require 'optparse'
require 'csv'

module ImportRank
  def self.import(filename)
    filepath = Rails.root.join(filename)
    ActiveRecord::Base.transaction do
      CSV.foreach(filepath, headers: true, header_converters: :symbol, row_sep: "\r\n", encoding: "SJIS") do |row|
        rank_params = parse_rank_params(row)
        word = Kw::Word.find_or_initialize_by(name: rank_params[:name])
        if word.update_attributes(rank_params)
          puts "success: #{rank_params[:name]}"
        else
          puts "Error: #{rank_params[:name]}"
        end
      end
    end
  end

  def self.parse_rank_params(row)
    new_hash = row.to_hash
    row = Hash[new_hash.map { |k,v| [k, "#{v.present? ? v.encode("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8") : nil}"]  }]
    {
      name: row[:""],
      rank: row[:google],
      rank_url: row[:google_url],
    }
  end
end

options = {}
banner = "Usage: rails runner db/script/import_rank.rb [options]"
OptionParser.new do |opts|
  opts.banner = banner
  opts.on("-f", "--file fILENAME", String, 'file') { |f| options[:filename] = f }
  opts.parse!(ARGV)
end

if options.present?
  ImportRank.import(options[:filename])
else
  puts banner
end