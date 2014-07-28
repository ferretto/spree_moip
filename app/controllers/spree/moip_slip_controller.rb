module Spree
  class MoipSlipController < Spree::StoreController
    skip_before_action :verify_authenticity_token, only: :notification
    before_filter :set_order, :only => [:generate_token]
    respond_to :json, :only => [:generate_token]

    def notification
      order = Spree::Order.find_by_number(params[:id_transacao].split("_").first)
      payment = order.payments.joins(:payment_method).where(:spree_payment_methods => {:type => 'Spree::PaymentMethod::MoipSlip' }).first
      payment.started_processing!

      if params[:status_pagamento].eql?('4') && (payment.amount * 100).to_i.to_s.eql?(params[:valor])
        logger.info "[MOIP] Order #{@order.number} approved"
        payment.complete!
        order.next
      else
        logger.info "[MOIP] Order #{@order.number} failed"
        payment.pend!
      end

      render nothing: true, status: :ok
    end

    def generate_token
      render :json => {:token => Spree::MoipWrapper.new(@order, @payment_method).generate_token}
    end

    private
    def set_order
      @order = current_order
      @payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
    end
  end
end
