class AddVisitedToMember < ActiveRecord::Migration
  def change
    add_column :members, :visited, :boolean
  end
end
