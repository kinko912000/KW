class AddSecondUrlToWord < ActiveRecord::Migration
  def change
    add_column :kw_words, :second_url, :text
  end
end
