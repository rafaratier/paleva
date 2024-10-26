class AddConstraintsToEstablishments < ActiveRecord::Migration[7.2]
  def change
    change_column_null :establishments, :trade_name, false
    change_column_null :establishments, :legal_name, false
    change_column_null :establishments, :business_national_id, false
    change_column_null :establishments, :phone, false
    change_column_null :establishments, :email, false
    change_column_null :establishments, :business_hours, false

    add_index :establishments, :business_national_id, unique: true
    add_index :establishments, :phone, unique: true
    add_index :establishments, :email, unique: true
  end
end
