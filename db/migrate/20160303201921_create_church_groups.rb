class CreateChurchGroups < ActiveRecord::Migration
  def change
    create_table :church_groups do |t|
t.string :name
t.string :leader
t.string :region 
      t.timestamps null: false
    end
  end
end
