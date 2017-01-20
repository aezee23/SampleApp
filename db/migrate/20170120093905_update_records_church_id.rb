class UpdateRecordsChurchId < ActiveRecord::Migration
  def change
  end
  Record.all.each do |record|
    record.update_column(:church_id, record.user.churches.first.id) if record.user.churches.first
  end
end
