# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MollieIdealExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/mollie_ideal"

  # Please use mollie_ideal/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem "mollie-ideal"
  end
  
  def activate
    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
    BillingIntegration::MollieIdeal.register
    
    #checkout_state_machine = Checkout.state_machines[:state]
    #checkout_state_machine.event :prev do
    #  transition :to => "payment", :from => "complete"
    #end
    
    #open up CheckoutsController so I can do a proper redirection.
    CheckoutsController.class_eval do
      
      def complete_checkout
        complete_order
        order_params = {:checkout_complete => true}
        if @checkout.payments.first.source_type == "IdealPayment"
          redirect_to @checkout.payments.first.source.payment_redirect_url
        else
          session[:order_id] = nil
          flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
          redirect_to order_url(@order, {:checkout_complete => true, :order_token => @order.token})
        end
      end
      
    end
    #END CheckoutsController
    
    
  end
end
