class BusinessHour < ApplicationRecord
  belongs_to :establishment

  enum :day_of_week, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  validates :day_of_week, :is_open, :open_time, :close_time, presence: true
  validates :is_open, inclusion: [ true, false ]
end
