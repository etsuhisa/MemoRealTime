class CreateHashTags < ActiveRecord::Migration[5.2]
  def change
    create_table :hash_tags do |t|
      t.bigint :memo_id
      t.string :tag

      t.timestamps
    end
  end
end
