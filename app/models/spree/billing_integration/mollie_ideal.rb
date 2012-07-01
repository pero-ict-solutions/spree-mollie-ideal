class Spree::BillingIntegration::MollieIdeal < Spree::BillingIntegration
  include Rails.application.routes.url_helpers
  preference :partner_id, :string
  preference :hostname, :string
  preference :callback_url, :string

  attr_accessible :preferred_partner_id, :preferred_hostname, :preferred_callback_url, :preferred_server, :preferred_test_mode

  def banklist
    ::Mollie::Ideal.testmode = preferred_test_mode
    ::Mollie::Ideal.banklist
  end

  def authorize(amount, payment, options)
    default_url_options[:host] = preferred_hostname
    ::Mollie::Ideal.testmode = preferred_test_mode
    ::Mollie.partner_id = preferred_partner_id
    description = "Betaling voor order nummer : #{'test'}"

    reporturl = ideal_callbacks_url
    if preferred_callback_url
      reporturl = preferred_callback_url
    end
    ideal_returns_url = "default-store.dev/ideal_returns"

    response = ::Mollie::Ideal.prepare_payment(payment.bank_id,amount,description, ideal_returns_url ,reporturl)
    self.transaction_id = response.transaction_id
    self.payment_redirect_url = response.URL
    self.save
  end

end
