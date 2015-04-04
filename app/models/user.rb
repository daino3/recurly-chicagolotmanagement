class User < ActiveRecord::Base
  has_many :properties

  def monthly_payments
    properties.reduce do |sum, property|
      sum + property.monthly_payment
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end