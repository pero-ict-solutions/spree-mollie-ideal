class PrefixTableNames < ActiveRecord::Migration
  def change
    rename_table :ideal_payments, :spree_ideal_payments
  end
end
