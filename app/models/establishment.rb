class Establishment < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  before_create :generate_code

  serialize :business_hours, coder: JSON

  validates :trade_name, :legal_name, :email, :business_national_id, :phone, :owner, :business_hours, presence: true
  validates :business_national_id, :email, :phone, :owner, uniqueness: true
  validates :trade_name, :legal_name, length: { minimum: 2, maximum: 25 }
  validates :phone, length: { minimum: 10, maximum: 11 }

  validates :email, email: true

  validate :validate_business_hours_format

  validate :business_national_id_must_be_valid_CNPJ

  private

  def validate_business_hours_format
    required_keys = [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]

    if !business_hours.is_a?(Hash)
      errors.add(:business_hours, :wrong_format)
    elsif business_hours.keys.map(&:to_s) != required_keys
      errors.add(:business_hours, :missing_week_days)
    end
  end

  def business_national_id_must_be_valid_CNPJ
    unless CNPJ.valid?(business_national_id)
      errors.add(:business_national_id)
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(10)
  end
end
