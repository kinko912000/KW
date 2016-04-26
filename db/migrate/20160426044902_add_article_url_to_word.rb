class AddArticleUrlToWord < ActiveRecord::Migration
  def change
    add_column :kw_words, :article_url, :string
  end
end
