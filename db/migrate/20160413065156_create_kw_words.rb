class CreateKwWords < ActiveRecord::Migration
  def change
    create_table :kw_words do |t|

      t.timestamps null: false
    end
  end
end
