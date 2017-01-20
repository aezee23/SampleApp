class ImportVisiRecords < ActiveRecord::Migration
  def change
  end
  Record.where(church_id: nil).destroy_all
  Record.all.each do |record|
    VisitationRecord.create(
      day: record.day,
      visitation: record.visitation,
      user_id: record.user_id
    )
  end
end
