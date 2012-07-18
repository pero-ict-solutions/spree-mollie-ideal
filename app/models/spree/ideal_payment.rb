module Spree
  class IdealPayment < ActiveRecord::Base
    attr_accessible :bank_id, :payment_redirect_url, :transaction_id

    has_many :payments, :as => :source

    class << self
      def current_payment_method
        Spree::PaymentMethod.find(:first, :conditions => {:type=> "Spree::PaymentMethod::MollieIdeal", :active => true, :environment => Rails.env})
      end
    end

    # fix for Payment#payment_profiles_supported?
    def payment_gateway
      false
    end

    def authorization
      nil
    end

    def is_payed?
      return self.verified unless self.verified.nil?
      Mollie.partner_id = IdealPayment.current_payment_method.preferred_partner_id
      Mollie::Ideal.testmode = IdealPayment.current_payment_method.preferred_test_mode
      self.verified = Mollie::Ideal.check_order(transaction_id).payed == "true"
      save
      self.verified
    end

    def success?
      true
    end

  end
end
