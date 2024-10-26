class AddEstablishmentIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :establishment
  end
end
