require 'spec_helper'

describe 'subscriptions_controller' do
  include FixtureLoader

  let(:params) { JSON.parse(load_fixture('valid_params.json')).with_indifferent_access }

  describe '#create' do

    it 'creates a user' do
      expect_any_instance_of(User).to receive(:create_stripe_subscription).with(params[:subscription_id], params[:properties].count)

      expect{
        post '/subscriptions/create', params
      }.to change(User, :count).by(1)
    end

    it 'creates a user\'s properties' do
      user = User.create!
      allow(User).to receive(:find_or_create_by).and_return(user)
      expect(user).to receive(:create_stripe_subscription).with(params[:subscription_id], params[:properties].count)

      expect{
        post '/subscriptions/create', params
      }.to change(Property, :count).by(2)

      expect(user.properties.count).to eq(2)
      expect(user.properties.first.subscription_id).to eq('basic')
    end
  end

end
