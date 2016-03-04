class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
t.date :day, index:true
t.integer :sunday_att
t.integer :weekday_att
t.integer :first_timers
t.integer :new_converts
t.integer :nbs
t.integer :fnb
t.string :message_sunday
t.string :message_weekday
t.string :preacher_sunday
t.string :preacher_weekday
t.references :user, index:true

      t.timestamps null: false
    end
     add_foreign_key :records, :users
  end
end
