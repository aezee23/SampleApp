class DeleteDupeUsers < ActiveRecord::Migration
  def change
    remove_index(:records, :name => 'index_records_on_day_and_user_id')
  end


end
