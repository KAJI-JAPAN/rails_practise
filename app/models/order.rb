class Order < ApplicationRecord
  belongs_to :customer

  enum :status, { pending: 0, processing: 1, shipped: 2, returned: 3 }
end
