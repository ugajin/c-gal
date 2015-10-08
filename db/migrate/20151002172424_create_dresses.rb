class CreateDresses < ActiveRecord::Migration
  def change
    create_table :dresses do |t|
      t.integer :dress_type_id

      t.timestamps null: false
    end
  end
end
