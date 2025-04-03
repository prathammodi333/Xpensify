class Settlement < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  belongs_to :payee, class_name: 'User'
  belongs_to :group

  validates :amount, numericality: { greater_than: 0 }
end