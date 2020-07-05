class RemoveAccessCntFromMemos < ActiveRecord::Migration[5.2]
  def change
    remove_column :memos, :access_cnt, :string
  end
end
