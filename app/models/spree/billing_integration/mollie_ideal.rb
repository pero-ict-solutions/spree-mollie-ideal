module Spree
  module BillingIntegration
    class MollieIdeal < BillingIntegration
      preference :partner_id, :string
      preference :hostname, :string
      preference :callback_url, :string

      def banklist
        Mollie::Ideal.testmode = IdealPayment.current_payment_method.preferred_test_mode
        Mollie::Ideal.banklist
      end

      def provider_class
        #ActiveMerchant::Billing::MollieIdealGateway
      end

      def payment_source_class
        IdealPayment
      end
    end
  end
end
