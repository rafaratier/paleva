class ChangeIsOpenColumnToString < ActiveRecord::Migration[7.2]
  def up
    change_column :business_hours, :is_open, :string
  end

  def down
    change_column :business_hours, :is_open, :boolean
  end
end
