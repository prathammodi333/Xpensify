class Expense < ApplicationRecord
  belongs_to :paid_by, class_name: 'User'
  belongs_to :group, optional: true
  has_many :expense_shares, dependent: :destroy
  has_many :users, through: :expense_shares
  validates :amount, numericality: { greater_than: 0 }
  validates :description, presence: true
end