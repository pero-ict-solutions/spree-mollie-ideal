# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MollieIdealExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/mollie_ideal"

  # Please use mollie_ideal/config/routes.rb instead for extension routes.
  def self.require_gems(config)
    config.gem "mollie-ideal", :version => '0.1.0', :lib => "mollie-ideal"
  end
  
  def activate
    # make your helper avaliable in all views
    #Spree::BaseController.class_eval do
    #  helper MollieIdealHelper
    #end
    
    BillingIntegration::MollieIdeal.register
    Checkout.class_eval do
    
      # checkout state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
      state_machine :initial => 'address' do
        after_transition :to => 'complete', :do => :complete_order
        before_transition :to => 'complete', :do => :process_payment
        event :next do
          transition :to => 'delivery', :from  => 'address'
          transition :to => 'payment', :from => 'delivery'
          transition :to => 'confirm', :from => 'payment'
          transition :to => 'complete', :from => 'confirm'
          transition :to => 'complete', :from => 'payment'
        end
      end
    end
    
    CheckoutsHelper.class_eval do
      def checkout_progress
        steps = Checkout.state_names.reject { |n| n == "complete" }.map do |state|
          text = t("checkout_steps.#{state}")

          css_classes = []
          current_index = Checkout.state_names.index(@checkout.state)
          state_index = Checkout.state_names.index(state)

          if state_index < current_index
            css_classes << 'completed'
            text = link_to text, edit_order_checkout_url(@order, :step => state)
          end

          css_classes << 'next' if state_index == current_index + 1
          css_classes << 'current' if state == @checkout.state
          css_classes << 'first' if state_index == 0
          css_classes << 'last' if state_index == Checkout.state_names.length - 1

          # It'd be nice to have separate classes but combining them with a dash helps out for IE6 which only sees the last class
          content_tag('li', content_tag('span', text), :class => css_classes.join('-'))
        end
        content_tag('ol', steps.join("\n"), :class => 'progress-steps', :id => "checkout-step-#{@checkout.state}") + '<br clear="left" />'
      end
    
    end
    
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
