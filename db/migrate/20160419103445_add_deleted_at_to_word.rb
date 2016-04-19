class AddDeletedAtToWord < ActiveRecord::Migration
  def change
    add_column :kw_words, :deleted_at, :datetime
  end
end
