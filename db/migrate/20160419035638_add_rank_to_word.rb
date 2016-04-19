class AddRankToWord < ActiveRecord::Migration
  def change
    add_column :kw_words, :rank, :integer
    add_column :kw_words, :rank_url, :string
  end
end
