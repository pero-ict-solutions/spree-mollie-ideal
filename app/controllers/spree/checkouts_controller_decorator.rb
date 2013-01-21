module Spree
  CheckoutController.class_eval do
    def completion_route
      if @order.payments.first.source_type == "Spree::IdealPayment"
        @order.payments.first.source.payment_redirect_url
      else
        order_path(@order)
      end
    end
    def before_complete
      logger.info "\n \n \n \n \n \n I'm In Before Complete!!!!! #{@order.state}  \n \n \n \n \n"
    end

    def before_confirm
      logger.info "\n \n \n \n \n \n I'm In Before Confirm!!!!! #{@order.state}  \n \n \n \n \n"
    end

    def after_confirm
      logger.info "\n \n \n \n \n \n I'm In After Confirm!!!!! #{@order.state}  \n \n \n \n \n"
    end

    def after_payment
      logger.info "\n \n \n \n \n \n I'm In After Payment!!!!! #{@order.state} \n \n \n \n \n"
    end
  end
end
