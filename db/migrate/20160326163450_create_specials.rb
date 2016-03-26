class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|

      t.timestamps null: false
    end
  end
end
