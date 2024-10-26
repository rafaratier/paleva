class AddConstraintsToAddresses < ActiveRecord::Migration[7.2]
  def change
    change_column_null :addresses, :street_name, false
    change_column_null :addresses, :street_number, false
    change_column_null :addresses, :neighborhood, false
    change_column_null :addresses, :city, false
    change_column_null :addresses, :state, false
    change_column_null :addresses, :country, false
  end
end
