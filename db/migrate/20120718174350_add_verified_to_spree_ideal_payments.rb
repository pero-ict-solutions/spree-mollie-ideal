class AddVerifiedToSpreeIdealPayments < ActiveRecord::Migration
  def change
    add_column :spree_ideal_payments, :verified, :boolean, default: nil
  end
end
