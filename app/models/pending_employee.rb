class PendingEmployee < ApplicationRecord
  belongs_to :establishment

  enum :status, { 'pending': 0, 'registered': 1 }, default: :pending

  validates :personal_national_id, uniqueness: true
  validates :personal_national_id, :email, presence: true
  validate :personal_national_id_must_be_valid_CPF
  validate :email_must_be_uniq
  validate :personal_national_id_must_be_uniq

  private

  def personal_national_id_must_be_valid_CPF
    unless CPF.valid?(personal_national_id)
      errors.add(:personal_national_id)
    end
  end
end
