class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
t.string :email
t.string :name
t.string :elder
t.references :church_group, index:true
t.string :password_digest
t.boolean :admin, default: false

      t.timestamps null: false
    end
  
  end
end
