class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :establishment, foreign_key: :owner_id, dependent: :destroy

  validates :name, :lastname, :personal_national_id, presence: true
  validates :name, :lastname, length: { minimum: 2, maximum: 25 }
  validates :password, length: { minimum: 12 }
  validates :email, :personal_national_id, uniqueness: true
  validate :personal_national_id_must_be_valid_CPF

  validates :email, email: true

  private

  def personal_national_id_must_be_valid_CPF
    unless CPF.valid?(personal_national_id)
      errors.add(:personal_national_id)
    end
  end
end
