class IdealPayment < ActiveRecord::Base
  include ActionController::UrlWriter
  
  has_many :payments, :as => :source
  class << self
    def current_payment_method
      PaymentMethod.find(:first, :conditions => {:type=> "BillingIntegration::MollieIdeal", :active => true, :environment => ENV['RAILS_ENV']}) 
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
  
  
  def authorize(amount, payment)
    
    default_url_options[:host] = IdealPayment.current_payment_method.preferred_hostname
    Mollie::Ideal.testmode = IdealPayment.current_payment_method.preferred_test_mode
    Mollie.partner_id = payment.payment_method.preferred_partner_id
    description = "Betaling voor order nummer : #{payment.order.number}"
    
    reporturl = ideal_callbacks_url
    if IdealPayment.current_payment_method.preferred_callback_url
      reporturl = IdealPayment.current_payment_method.preferred_callback_url
    end
  
    response = Mollie::Ideal.prepare_payment(self.bank_id,amount,description, ideal_returns_url ,reporturl)
    self.transaction_id = response.transaction_id
    self.payment_redirect_url = response.URL
    self.save
  end
  
  # fix for Payment#payment_profiles_supported?
  def payment_gateway
    false
  end
  
end
