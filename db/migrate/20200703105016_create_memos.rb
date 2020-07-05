class CreateMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :memos do |t|
      t.string :title
      t.text :text
      t.datetime :access_at
      t.integer :access_cnt

      t.timestamps
    end
  end
end
