module Spree
  class MoipSlipController < Spree::BaseController
    before_filter :set_order
    def create
      @slip = MoipSlip.create(order: @order)
      # cria o boleto no moip
      payment= Spree::Payment.create!({
        :order => @order,
        :source => @slip,
        :amount => @order.total,
        :payment_method => Spree::PaymentMethod.find(params[:payment_method_id])
      })
      moip_slip_request = Spree::MoipWrapper.new(payment).generate_slip
      if moip_slip_request.success?
        redirect_to moip_slip_request.url
      end
    end

    def show
      #mostra o boleto
    end

    private
    def set_order
      @order = current_order
    end

  end
end
