class RemoveBusinessHoursFromEstablishment < ActiveRecord::Migration[7.2]
  def change
    remove_column :establishments, :business_hours, :integer
  end
end
