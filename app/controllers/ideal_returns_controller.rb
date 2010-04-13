class IdealReturnsController < ApplicationController
  
  def index
    Rails.logger.info "[IDEAL] GET return received from mollie"
    transaction_id = params[:transaction_id]
    payment = IdealPayment.find_by_transaction_id(transaction_id)
    if payment.is_payed?
      payment.payments.first.finalize!
      session[:order_id] = nil
      flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
      redirect_to order_url(payment.payments.first.order, {:checkout_complete => true, :order_token => payment.payments.first.order.token}) 
    else
      payment.payments.first.order.checkout.prev!
      flash[:notice] = "Kies aub een andere betaalmethode. iDEAL betaling is niet gelukt of afgebroken."
      redirect_to order_url(payment.payments.first.order)
    end
  end
  
end
