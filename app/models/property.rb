class Property < ActiveRecord::Base
  belongs_to :user

  def monthly_payment
    Stripe::Plan.retrieve(subscription_id).amount
  end
end
