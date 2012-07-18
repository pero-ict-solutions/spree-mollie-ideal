module Spree
  class IdealReturnsController < ApplicationController
    def index
      Rails.logger.info "[IDEAL] GET return received from mollie"
      transaction_id = params[:transaction_id]
      payment = ::Spree::IdealPayment.find_by_transaction_id(transaction_id)
      order = payment.payments.first.order
      if order.complete?
        flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
        session[:order_id] = nil
        redirect_to order_url(payment.payments.first.order, {:checkout_complete => true, :order_token => order.token})
      else
        if payment.is_payed?
          payment.payments.first.complete!
          session[:order_id] = nil
          flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
          redirect_to order_url(payment.payments.first.order, {:checkout_complete => true, :order_token => order.token})
        else
          flash[:notice] = "iDEAL betaling is niet gelukt of afgebroken. U kunt de bestelling via een bankoverschrijving voldoen."
          session[:order_id] = nil
          redirect_to order_url(payment.payments.first.order)
        end
      end
    end
  end
end
