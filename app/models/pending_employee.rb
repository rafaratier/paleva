class PendingEmployee < ApplicationRecord
  belongs_to :establishment

  validates :personal_national_id, :email, uniqueness: true
  validates :personal_national_id, :email, presence: true
end
