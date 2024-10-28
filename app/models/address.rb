class Address < ApplicationRecord
  belongs_to :establishment

  validates :street_name, :street_number, :neighborhood, :city, :state, :country, presence: true

  validates :street_name, :neighborhood, :city, :state, :country, length: { minimum: 4, maximum: 50 }
end
