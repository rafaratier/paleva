class Establishment < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id", optional: true
  has_many :employees, class_name: "User", foreign_key: "establishment_id", dependent: :destroy
  has_many :pending_employees, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :business_hours, dependent: :destroy
  accepts_nested_attributes_for :address

  before_create :generate_code

  after_create :initialize_business_hours

  validates :trade_name, :legal_name, :email, :business_national_id, :phone, :owner, presence: true
  validates :legal_name, :business_national_id, :email, :phone, :owner, uniqueness: true
  validates :trade_name, :legal_name, length: { minimum: 2, maximum: 25 }
  validates :phone, length: { minimum: 10, maximum: 11 }

  validates :email, email: { message: :invalid }

  validate :business_national_id_must_be_valid_CNPJ

  validate :unique_trade_name_within_state

  def opened_for_business?
    business_hours.exists?(status: "opened")
  end

  private

  def initialize_business_hours
    BusinessHour.day_of_weeks.keys.each do |day|
      business_hours.create(day_of_week: day, status: "closed")
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(10)
  end

  def business_national_id_must_be_valid_CNPJ
    unless CNPJ.valid?(business_national_id)
      errors.add(:business_national_id, :invalid)
    end
  end

  def unique_trade_name_within_state
    if address && Establishment.joins(:address)
                               .where(trade_name: trade_name, addresses: { state: address.state })
                               .where.not(id: id)
                               .exists?
      errors.add(:trade_name, :taken)
    end
  end
end
