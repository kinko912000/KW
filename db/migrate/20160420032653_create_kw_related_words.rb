class CreateKwRelatedWords < ActiveRecord::Migration
  def change
    create_table :kw_related_words do |t|
      t.integer :parent_id, null: false, index: true
      t.integer :child_id, null: false, index: true
      t.boolean :same, default: false, index: true
      t.timestamps null: false
    end
  end
end
