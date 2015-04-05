require 'spec_helper'

describe 'property_controller' do
  include FixtureLoader

  describe '#delete' do
    let!(:user) { User.create!(stripe_id: 'cus_5zwokvkevI45Hg') }
    let!(:property) { Property.create!(user: user, subscription_type: 'basic')  }

    it 'creates a user' do
      subscription = double(:subscription, quantity: 3)
      subscriptions = double(:subsciptions_list, retrieve: subscription)
      customer = double(:stripe_customer, subscriptions: subscriptions)
      expect(Stripe::Customer).to receive(:retrieve).with(user.stripe_id).and_return(customer)
      expect(customer).to receive(:update_subscription).with({plan: 'basic', quantity: 2})

      expect {
        post "/property/#{property.id}"
      }.to change(Property, :count).by(-1)
    end

  end

end