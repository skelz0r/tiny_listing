class CreateLoots < ActiveRecord::Migration
  def change
    create_table :loots do |t|
      t.text :link
      t.string :name
      t.string :name_sanitize
      t.string :extension
      t.integer :size, limit: 8
      t.integer :repository_id

      t.timestamps
    end
  end
end
