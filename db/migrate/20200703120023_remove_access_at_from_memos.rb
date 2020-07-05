class RemoveAccessAtFromMemos < ActiveRecord::Migration[5.2]
  def change
    remove_column :memos, :access_at, :string
  end
end
