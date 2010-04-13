class AddTransactionIdAndRedirectUrlToPayment < ActiveRecord::Migration
  def self.up
    add_column :ideal_payments, :transaction_id, :string
    add_column :ideal_payments, :payment_redirect_url, :string
  end

  def self.down
    remove_column :ideal_payments, :payment_redirect_url
    remove_column :ideal_payments, :transaction_id
  end
end