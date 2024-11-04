class BusinessHour < ApplicationRecord
  belongs_to :establishment

  enum :day_of_week, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

  validates :day_of_week, :status, presence: true
  validates :status, inclusion: [ "opened", "closed" ]

  validate :close_time_must_postdate_open_time

  private

  def close_time_must_postdate_open_time
    return if open_time.blank? || close_time.blank? || status == "closed"

    if open_time >= close_time
      errors.add(:close_time, :postdating)
    end
  end
end
