module Spree
  class PaymentMethod::MoipSlip < PaymentMethod
    preference :server, :string, default: 'sandbox'
    preference :sandbox_token, :string
    preference :sandbox_key, :string
    preference :production_token, :string
    preference :production_key, :string

    def actions
      %w{capture void}
    end

    def can_capture?(payment)
      ['processing','checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def source_required?
      true
    end

    def payment_source_class
      MoipSlip
    end
  end
end
