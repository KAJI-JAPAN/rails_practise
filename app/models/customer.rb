class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end
end
