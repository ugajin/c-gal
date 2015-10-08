class CreateDressTypes < ActiveRecord::Migration
  def change
    create_table :dress_types do |t|
      t.string :name
      

      t.timestamps null: false
    end
  end
end
