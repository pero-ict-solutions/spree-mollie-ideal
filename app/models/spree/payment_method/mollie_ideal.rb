module Spree
  class PaymentMethod::MollieIdeal < PaymentMethod
    include Spree::Core::Engine.routes.url_helpers
    preference :partner_id, :string
    preference :hostname, :string
    preference :test_mode, :boolean

    attr_accessible :preferred_partner_id, :preferred_hostname, :preferred_server, :preferred_test_mode

    has_many :payments, :as => :source

    def actions
      %w{capture}
    end

    def banklist
      ::Mollie::Ideal.testmode = preferred_test_mode
      ::Mollie::Ideal.banklist
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def purchase(amount, payment, options)
      capture(amount, payment, options)
    end

    def capture(amount, payment, options)
      default_url_options[:host] = preferred_hostname
      ::Mollie::Ideal.testmode = preferred_test_mode
      ::Mollie.partner_id = preferred_partner_id
      description = "Betaling voor order nummer : #{'test'}"


      response = ::Mollie::Ideal.prepare_payment(payment.bank_id,
                                                 amount,
                                                 description,
                                                 ideal_returns_url,
                                                 ideal_callbacks_url)

      payment.transaction_id = response.transaction_id
      payment.payment_redirect_url = response.URL
      payment.save
      payment
    end

    def payment_source_class
      Spree::IdealPayment
    end

    def source_required?
      true
    end

    def provider_class
      self.class
    end

    # fix for Payment#payment_profiles_supported?
    def payment_gateway
      false
    end
  end
end
