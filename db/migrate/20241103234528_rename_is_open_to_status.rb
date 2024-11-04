class RenameIsOpenToStatus < ActiveRecord::Migration[7.2]
  def change
    rename_column :business_hours, :is_open, :status
  end
end
