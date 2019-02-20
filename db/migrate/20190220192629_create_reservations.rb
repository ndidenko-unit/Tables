class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :table_id
      t.integer :user_id

      t.timestamps
    end
  end
end
