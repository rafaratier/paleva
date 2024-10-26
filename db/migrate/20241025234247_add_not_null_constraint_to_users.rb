class AddNotNullConstraintToUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :lastname, false
    change_column_null :users, :personal_national_id, false
    add_index :users, :personal_national_id, unique: true
  end
end
