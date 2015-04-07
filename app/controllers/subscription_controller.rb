module ChicagoLotManagement
  class App < Sinatra::Base

    get '/plan-data' do
      content_type :json

      @pricing = Stripe::Plan.all.data.inject({}) do |hash, obj|
        hash[obj.id] = obj.amount / 100; hash
      end.to_json
    end

    get '/subscribe-observation' do
      @plan = Stripe::Plan.retrieve("observation")
      slim :form, layout: true
    end

    get '/subscribe-basic' do
      @plan = Stripe::Plan.retrieve("basic")
      slim :form, layout: true
    end

    get '/subscribe-premium' do
      @plan = Stripe::Plan.retrieve("premium")
      slim :form, layout: true
    end

    post '/subscriptions/create' do
      begin
        account = params[:account].first
        user = User.find_or_create_by(email: account[:email])
        user.update_attributes(account)

        subscription = user.create_stripe_subscription(params[:subscription_type], params[:properties].count)

        params[:properties].each do |property|
          prop_attributes = property.merge(
            user: user,
            subscription_type: params[:subscription_type],
            subscription_id: subscription.id
          )

          Property.create!(prop_attributes)
        end

      rescue  ActiveRecord::Error => e
        puts e.message
      ensure
        redirect back
      end
    end
  end
end