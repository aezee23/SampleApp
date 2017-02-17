class AddAvatarToChurches < ActiveRecord::Migration
  def change
    add_column :churches, :avatar, :string
  end
end
