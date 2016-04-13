class CreateKwWords < ActiveRecord::Migration
  def change
    create_table :kw_words do |t|

      t.string :name, null: false, index: true
      t.timestamps null: false
    end
  end
end
