class AddVisitationToRecords < ActiveRecord::Migration
  def change
    add_column :records, :visitation, :boolean
  end
end
