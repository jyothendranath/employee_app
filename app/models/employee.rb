class Employee < ApplicationRecord
  serialize :phone_numbers, Array
  validates :first_name, :last_name, :email, :date_of_joining,:phone_numbers, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }

  # validates :date_of_joining, presence: true, timeliness: { type: :date }

  validates :salary, numericality: { greater_than_or_equal_to: 0 }
end
