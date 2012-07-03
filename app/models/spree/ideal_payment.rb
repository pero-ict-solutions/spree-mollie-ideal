module Spree
  class IdealPayment < ActiveRecord::Base
    attr_accessible :bank_id

    class << self
      def current_payment_method
        PaymentMethod.find(:first, :conditions => {:type=> "Spree::BillingIntegration::MollieIdeal", :active => true, :environment => ENV['RAILS_ENV']})
      end
    end

    def process!(payment)
      amount = (payment.amount.to_f * 100).to_i
      authorize(amount, payment)
    end

    def completed?
      true
    end

    def success?
      true
    end

    def is_payed?
      Mollie.partner_id = IdealPayment.current_payment_method.preferred_partner_id
      Mollie::Ideal.testmode = IdealPayment.current_payment_method.preferred_test_mode
      Mollie::Ideal.check_order(transaction_id).payed == "true"
    end

    # fix for Payment#payment_profiles_supported?
    def payment_gateway
      false
    end
  end
end
