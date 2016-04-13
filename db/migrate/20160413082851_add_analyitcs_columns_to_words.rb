class AddAnalyitcsColumnsToWords < ActiveRecord::Migration
  def change
    add_column :kw_words, :fetched, :boolean, default: false
    add_column :kw_words, :selected, :boolean, default: false
    add_column :kw_words, :avg_searches, :integer
    add_column :kw_words, :competition, :decimal, precision: 3, scale: 2
    add_column :kw_words, :suggested_bid, :integer
    add_column :kw_words, :primary_url, :string
  end
end
