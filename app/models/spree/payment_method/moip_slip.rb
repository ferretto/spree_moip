module Spree
  class PaymentMethod::MoipSlip < PaymentMethod
    preference :server, :string, default: 'sandbox'
    preference :sandbox_token, :string
    preference :sandbox_key, :string
    preference :production_token, :string
    preference :production_key, :string
    preference :expiration_days_after_slip_creation, :integer, default: 3
    preference :real_expiration_days, :integer, default: 5
    preference :expiration_days_type, :string, default: 'business_day'
    preference :instruction_line_1, :string
    preference :instruction_line_2, :string
    preference :instruction_line_3, :string
    preference :logo_url, :string
    preference :payment_reason, :string, default: Spree::Config.site_name

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
      false
    end
  end
end
