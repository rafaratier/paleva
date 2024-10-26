class Establishment < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_one :address, dependent: :destroy
end
