class ChangeSelectedFromWord < ActiveRecord::Migration
  def change
    change_column :kw_words, :selected, :boolean, default: true
  end
end
