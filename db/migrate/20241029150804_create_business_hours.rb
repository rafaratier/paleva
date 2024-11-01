class CreateBusinessHours < ActiveRecord::Migration[7.2]
  def change
    create_table :business_hours do |t|
      t.references :establishment, null: false, foreign_key: true
      t.integer :day_of_week
      t.boolean :is_open
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
