module Spree
  class MoipSlipController < Spree::StoreController
    skip_before_action :verify_authenticity_token, only: :notification
    before_filter :set_order
    respond_to :json, :only => [:generate_token]

    def notification
      payment = Spree::Payment.find_by_identifier(params[:id_transacao])
      payment.started_processing!

      if params[:status_pagamento].eql?('4') && (payment.amount * 100).to_i.to_s.eql?(params[:valor])
        logger.info "[MOIP] Order #{@order.number} approved"
        payment.complete!
        @order.next
      else
        logger.info "[MOIP] Order #{@order.number} failed"
        payment.pend!
      end

      render nothing: true, status: :ok
    end

    def generate_token
      @order.payments.create(order: @order, amount: @order.total, payment_method: @payment_method)
      render :json => {:token => Spree::MoipWrapper.new(@order, @payment_method).generate_token}
    end

    private
    def set_order
      @order = current_order
      @payment_method = Spree::PaymentMethod.find(params[:payment_method_id]) if params[:payment_method_id]
    end
  end
end
