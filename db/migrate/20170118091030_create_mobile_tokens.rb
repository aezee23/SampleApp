class CreateMobileTokens < ActiveRecord::Migration
  def change
    create_table :mobile_tokens do |t|
      t.string :auth_token
      t.string :name
      t.timestamps
    end
  end
end
