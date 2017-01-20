class ImportVisitationRecords < ActiveRecord::Migration
  def change
    add_column :visitation_records, :user_id, :integer
  end

end
