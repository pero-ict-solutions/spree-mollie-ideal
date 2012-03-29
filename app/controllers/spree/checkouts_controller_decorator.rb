module Spree
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
end
