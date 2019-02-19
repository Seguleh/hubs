class CreateHubs < ActiveRecord::Migration[5.2]
  def change
    create_table :hubs do |t|
      t.string :country_code
      t.string :locode
      t.string :name
      t.string :dia_name
      t.string :function
      t.string :status
      t.string :date
      t.string :iata
      t.float  :lat
      t.float  :lon
      t.timestamps
    end
  end
end
