module ChicagoLotManagement
  class App < Sinatra::Base

    post '/property/:id' do
      property = Property.find(params[:id])
      user = property.user

      customer = Stripe::Customer.retrieve(user.stripe_id)
      subscription = customer.subscriptions.retrieve(property.subscription_id)
      customer.update_subscription(plan: property.subscription_type, quantity: subscription.quantity - 1)

      property.destroy
      redirect to('/admin')
    end

    get '/add-property' do
      @property_count = params[:count].to_i
      slim :'/_property', layout: false
    end

  end
end