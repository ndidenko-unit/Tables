class AddIndexToReservation < ActiveRecord::Migration[5.2]
  def change
    add_index :reservations, :table_id
    add_index :reservations, :user_id
    add_index :reservations, :start_time
    add_index :reservations, :end_time
  end
end
