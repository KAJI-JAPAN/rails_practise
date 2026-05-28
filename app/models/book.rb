class Book < ApplicationRecord
  belongs_to :author

  # ガイドの例文に合わせて status を3値の enum にする
  enum :status, { available: 0, unavailable: 1, out_of_print: 2 }
end
