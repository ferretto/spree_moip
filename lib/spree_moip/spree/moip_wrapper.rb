require 'mymoip'
module Spree
  class MoipWrapper
    attr_accessor :order, :payment_method

    def initialize(order, payment_method)
      @order = order
      @payment_method = payment_method
      set_configs
    end

    def generate_token
      if !@order.moip_tokens.where(amount: @order.total).any?
        @order.moip_tokens.create!(token: transparent_request.token, amount: @order.total)
      end
      @order.moip_tokens.where(amount: @order.total).first.token
    end

    private
    def transparent_request
      transparent_request = MyMoip::TransparentRequest.new(uniq_transaction_id)
      transparent_request.api_call(instruction)
      transparent_request
    end

    def uniq_transaction_id
      "#{order.number}_#{(order.total * 100).to_i}"
    end

    def instruction
      MyMoip::Instruction.new(
        id:               uniq_transaction_id,
        payment_reason:   preferences[:payment_reason],
        values:           [order.total.to_f],
        payer:            payer,
        payment_methods:  payment_methods,
        payment_slip:     payment_slip,
        notification_url: "#{Spree::Config.site_url}moip/notification"
      )
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


    def payment_methods
      MyMoip::PaymentMethods.new(
        payment_slip: true,
        credit_card:  false,
        debit:        false,
        debit_card:   false,
        financing:    false,
        moip_wallet:  false
      )
    end

    def payment_slip
      MyMoip::PaymentSlip.new(
        expiration_date:      slip_expiration_date,
        expiration_days:      preferences[:expiration_days_after_slip_creation] + preferences[:real_expiration_days],
        expiration_days_type: preferences[:expiration_days_type].to_sym,
        instruction_line_1:   preferences[:instruction_line_1],
        instruction_line_2:   preferences[:instruction_line_2],
        instruction_line_3:   preferences[:instruction_line_3],
        logo_url:             preferences[:logo_url]
      )
    end

    def slip_expiration_date
      (Date.today.next_day + preferences[:expiration_days_after_slip_creation]).to_datetime
    end

    def preferences
      payment_method.preferences
    end

    def set_configs
      MyMoip.environment =      preferences[:server]
      MyMoip.sandbox_token    = preferences[:sandbox_token]
      MyMoip.sandbox_key      = preferences[:sandbox_key]
      MyMoip.production_token = preferences[:production_token]
      MyMoip.production_key   = preferences[:production_key]
    end
  end
end
