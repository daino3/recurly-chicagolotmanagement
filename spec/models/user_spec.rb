require 'spec_helper'

describe 'subscriptions#create' do
  include FixtureLoader

  let(:account) { JSON.parse(load_fixture('valid_params.json')).with_indifferent_access[:account] }
  let(:user) { User.create(account).first }

  describe '#create_stripe_subscription' do

    it 'creates a Stripe customer and subscribes them to a plan' do
      stripe_id = SecureRandom.hex(8)
      stripe_customer = double(:stripe_customer, id: stripe_id)
      expect(Stripe::Customer).to receive(:create).and_return(stripe_customer)
      expect(stripe_customer).to receive(:update_subscription)

      user.create_stripe_subscription('basic', 2)

      expect(user.stripe_id).to eq(stripe_id)
    end
  end

  describe '#monthly_payments' do

    it 'returns the subscription monthly grand total' do
      property = double(:property_double, monthly_payment: 10)
      properties = [property, property, property]
      allow(user).to receive(:properties).and_return(properties)

      expect(user.monthly_payments).to eq(properties.count * 10)
    end
  end

end
