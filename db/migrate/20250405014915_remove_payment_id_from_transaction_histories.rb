class RemovePaymentIdFromTransactionHistories < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :transaction_histories, :payments
    remove_column :transaction_histories, :payment_id, :integer
  end
end