require 'mymoip'
module Spree
  class MoipWrapper
    attr_accessor :order, :payment

    def initialize(payment)
      @payment = payment
      @order = payment.order
      set_configs
    end

    def generate_slip
      payment_slip_payment = MyMoip::PaymentSlipPayment.new()
      payment_request      = MyMoip::PaymentRequest.new(order.number)
      payment_request.api_call(payment_slip_payment, token: a.token)
      payment_request
    end

    private
    def transparent_request
      transparent_request = MyMoip::TransparentRequest.new(order.number)
      transparent_request.api_call(instruction)
      transparent_request
    end

    def payer
      user = order.user
      address = order.bill_address
      state = address.state
      country = address.country
      MyMoip::Payer.new(
        id:                    user.id,
        name:                  order.name,
        email:                 order.email,
        address_street:        address.address1,
        address_street_number: '0',
        address_street_extra:  address.address2,
        address_neighbourhood: 'BR',
        address_city:          address.city,
        address_state:         state.abbr,
        address_country:       country.iso3,
        address_cep:           address.zipcode,
        address_phone:         address.phone
      )
    end

    def instruction
      MyMoip::Instruction.new(
        id:             order.number,
        payment_reason: Spree::Config.site_name,
        values:         [order.amount.to_f],
        payer:          payer
      )
    end

    def set_configs
      config = payment.payment_method.preferences
      MyMoip.environment = config[:server]
      MyMoip.sandbox_token    = config[:sandbox_token]
      MyMoip.sandbox_key      = config[:sandbox_key]
      MyMoip.production_token = config[:production_token]
      MyMoip.production_key   = config[:production_key]
    end
  end
end
