class Establishment < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_one :address, dependent: :destroy

  serialize :business_hours, coder: JSON

  validates :trade_name, :legal_name, :email, :business_national_id, :phone, :owner, :business_hours, presence: true
  validates :business_national_id, :email, :phone, :owner, uniqueness: true
  validates :trade_name, :legal_name, length: { minimum: 2, maximum: 25 }
  validates :business_national_id, length: { is: 18 }
  validates :phone, length: { minimum: 10, maximum: 11 }

  validates :email, email: true

  validate :validate_business_hours_format

  private

  def validate_business_hours_format
    required_keys = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]

    if !business_hours.is_a?(Hash)
      errors.add(:business_hours, :wrong_format)
    elsif business_hours.keys.map(&:to_s) != required_keys
      errors.add(:business_hours, :missing_week_days)
    end
  end
end
