class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.datetime :open_time
      t.datetime :close_time

      t.timestamps
    end
  end
end
