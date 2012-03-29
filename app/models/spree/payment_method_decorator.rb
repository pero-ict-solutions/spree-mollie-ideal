module Spree
  PaymentMethod.class_eval do
    def payment_profiles_supported?
      true
    end
  end
end
