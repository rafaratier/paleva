class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :street_name
      t.integer :street_number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
