class AddColumnsToMemo < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :color, :string
  end
end
