class DeleteDupeUserAccounts < ActiveRecord::Migration
  def change
  end
  dans = User.where(name: "Daniel Adjei")
  dan1, dan2 = dans
  dan1.records.each { |record| record.update_column(:user_id, dan2.id) }
  dan1.churches.first.update_column(:user_id, dan2)
  dan1.destroy

  kojos = User.where(name: "Kojo Sarbeng")
  kojo1, kojo2 = kojos
  kojo1.records.each { |record| record.update_column(:user_id, kojo2.id) }
  kojo1.churches.first.update_column(:user_id, kojo2)
  kojo1.destroy

  emans = User.where(name: "Emmanuel Baiden")
  eman1, eman2 = emans
  eman1.records.each { |record| record.update_column(:user_id, eman2.id) }
  eman1.churches.first.update_column(:user_id, eman2)
  eman1.destroy

end
