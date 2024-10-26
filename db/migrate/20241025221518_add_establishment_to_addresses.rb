class AddEstablishmentToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_reference :establishment, :address, foreign_key: true
  end
end
