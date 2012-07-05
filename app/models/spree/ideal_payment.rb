module Spree
  class IdealPayment < ActiveRecord::Base
    attr_accessible :bank_id

    class << self
      def current_payment_method
        PaymentMethod.find(:first, :conditions => {:type=> "Spree::PaymentMethod::MollieIdeal", :active => true, :environment => ENV['RAILS_ENV']})
      end
    end

    def process!(payment)
      amount = (payment.amount.to_f * 100).to_i
      authorize(amount, payment)
    end

    def is_payed?
      Mollie.partner_id = IdealPayment.current_payment_method.preferred_partner_id
      Mollie::Ideal.testmode = IdealPayment.current_payment_method.preferred_test_mode
      Mollie::Ideal.check_order(transaction_id).payed == "true"
    end

  end
end
