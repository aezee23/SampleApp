class AddBaptisedToRecords < ActiveRecord::Migration
  def change
      add_column :records, :baptised, :integer, default: 0
  end
end
