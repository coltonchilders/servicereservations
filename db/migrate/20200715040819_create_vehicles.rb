class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.belongs_to :customer, index: true, foreign_key: true
      t.string :make
      t.string :model
      t.integer :year
      t.string :vin
      t.string :color
      t.integer :mileage
      t.string :license

      t.timestamps
    end
  end
end
