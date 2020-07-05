class AddCategoryToMemo < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :Memo, :string
    add_column :memos, :category_id, :bigint
  end
end
