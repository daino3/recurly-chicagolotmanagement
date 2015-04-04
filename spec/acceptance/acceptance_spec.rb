require 'spec_helper'

describe 'route' do
  include FormHelper

  xcontext 'observation package' do
    it 'creates a user' do
      expect{
        complete_form '/subscribe-observation'
      }.to change(User, :count).by(1)
    end
  end

  xcontext 'basic package' do
    it 'creates a user' do
      expect{
        complete_form '/subscribe-basic'
      }.to change(User, :count).by(1)
    end
  end

  xcontext 'premium package' do
    it 'creates a user' do
      expect{
        complete_form '/subscribe-premium'
      }.to change(User, :count).by(1)
    end
  end
end
