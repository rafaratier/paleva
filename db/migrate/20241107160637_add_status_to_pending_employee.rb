class AddStatusToPendingEmployee < ActiveRecord::Migration[7.2]
  def change
    add_column :pending_employees, :status, :integer, limit: 1
  end
end
