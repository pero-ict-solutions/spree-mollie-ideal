module Spree
  class PaymentMethod::MollieIdeal < PaymentMethod
    include Spree::Core::Engine.routes.url_helpers
    preference :partner_id, :string
    preference :hostname, :string
    preference :test_mode, :boolean

    attr_accessible :preferred_partner_id, :preferred_hostname, :preferred_server, :preferred_test_mode

    has_many :payments, :as => :source

    def banklist
      ::Mollie::Ideal.testmode = preferred_test_mode
      ::Mollie::Ideal.banklist
    end

    def authorize(amount, payment, options)
      capture(amount, payment, options)
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

  end
end
