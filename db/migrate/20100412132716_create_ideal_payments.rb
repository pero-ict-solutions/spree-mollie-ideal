class CreateIdealPayments < ActiveRecord::Migration
  def self.up
    create_table :ideal_payments do |t|
      t.string :bank_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ideal_payments
  end
end
