class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :owned_establishment, class_name: "Establishment", foreign_key: "owner_id", dependent: :destroy
  belongs_to :establishment, optional: true

  enum :role, { owner: 0, employee: 1 }

  validates :role, :email, :personal_national_id, presence: true
  validates :name, :lastname, length: { minimum: 2, maximum: 25 }
  validates :password, length: { minimum: 12 }
  validates :email, :personal_national_id, uniqueness: true
  validate :personal_national_id_must_be_valid_CPF
  validate :employee_allowed_by_owner_to_register

  private

  def employee_allowed_by_owner_to_register
    return if role == "owner"

    unless PendingEmployee.find_by(personal_national_id: personal_national_id)
        errors.add(:role, :not_allowed)
    end
  end

  def personal_national_id_must_be_valid_CPF
    unless CPF.valid?(personal_national_id)
      errors.add(:personal_national_id)
    end
  end
end
