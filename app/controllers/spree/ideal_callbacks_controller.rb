module Spree
  class IdealCallbacksController < ApplicationController
    def index
      Rails.logger.info "[IDEAL] GET callback received from mollie"
      transaction_id = params[:transaction_id]
      payment = ::Spree::IdealPayment.find_by_transaction_id(transaction_id)
      if payment.is_payed?
        payment.payments.first.complete!
      end
      render :text => "OK"
    end
  end
end
