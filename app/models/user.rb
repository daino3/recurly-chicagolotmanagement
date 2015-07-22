class User < ActiveRecord::Base
  has_many :properties

  def monthly_payments
    # alternatively, you could use Stripe::Customer.retrieve(:stride_id).invoices.inject(0)...
    properties.reduce(0) do |sum, property|
      sum + property.monthly_payment
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def stripe_description
    "#{email} - #{full_name}"
  end

  def create_stripe_subscription(plan, quantity)
    if !stripe_token.present?
      raise "We're doing something wrong -- this isn't supposed to happen"
    end

    customer = Stripe::Customer.create(
      :email => email,
      :description => stripe_description,
      :card => stripe_token,
      :metadata => properties.all.map(&:attributes),
      :coupon => promo_code
    )

    self.update_attribute(:stripe_id, customer.id)

    customer.create_subscription({:plan => plan, quantity: quantity})
  end


end