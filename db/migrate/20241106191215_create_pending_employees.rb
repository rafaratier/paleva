class CreatePendingEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :pending_employees do |t|
      t.string :email
      t.string :personal_national_id
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
