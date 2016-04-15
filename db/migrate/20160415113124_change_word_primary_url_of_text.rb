class ChangeWordPrimaryUrlOfText < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column :kw_words, :primary_url, :text
      end

      dir.down do
        change_column :kw_words, :primary_url, :string
      end
    end
  end
end
