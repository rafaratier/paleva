class CreateEstablishments < ActiveRecord::Migration[7.2]
  def change
    create_table :establishments do |t|
      t.string :trade_name
      t.string :legal_name
      t.string :business_national_id
      t.string :phone
      t.string :email
      t.text :business_hours

      t.timestamps
    end
  end
end
