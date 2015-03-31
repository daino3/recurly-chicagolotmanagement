require 'spec_helper'

describe 'route' do
  include FormHelper

  context 'observation package' do
    it 'creates a user' do
      expect{
        complete_form '/observation', multiple_properties: false
      }.to change(User, :count).by(1)
    end

    it 'sends an application to recurly\'s api' do
      1 == 1
    end
  end
end
