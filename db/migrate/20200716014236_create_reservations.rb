class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :customer, index: true, foreign_key: true
      t.belongs_to :vehicle, foreign_key: true
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :hour
      t.integer :minute
      t.string :employee

      t.timestamps
    end
  end
end
