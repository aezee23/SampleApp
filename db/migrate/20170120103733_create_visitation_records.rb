class CreateVisitationRecords < ActiveRecord::Migration
  def change
    create_table :visitation_records do |t|
      t.date :day
      t.boolean :visitation
      t.timestamps
    end
  end
end
