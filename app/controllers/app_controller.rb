module ChicagoLotManagement
  class App < Sinatra::Base

    before do
      @pricing = Stripe::Plan.all.data.inject({}) do |hash, obj|
        hash[obj.id] = obj.amount / 100; hash
      end.to_json
    end

    get '/subscribe-observation' do
      @plan = Stripe::Plan.retrieve("Observation")
      slim :advanced
    end

    get '/subscribe-basic' do
      @plan = Stripe::Plan.retrieve("Basic")
      slim :advanced
    end

    get '/subscribe-premium' do
      @plan = Stripe::Plan.retrieve("premium")
      slim :advanced
    end

    post '/api/subscriptions/new' do
      begin
        subscription = Recurly::Subscription.create plan_code: 'kale-fan',
          account: {
            account_code: SecureRandom.uuid,
            first_name: params['first-name'],
            last_name: params['last-name'],
            email: params['email'],
            billing_info: {
              token_id: params['stripe-token']
            }
          }
      rescue Recurly::Resource::Invalid, Recurly::API::ResponseError => e
        puts e
      ensure
        redirect back
      end
    end

    post '/api/accounts/new' do
      begin
        Recurly::Account.create! account_code: SecureRandom.uuid,
          billing_info: { token_id: params['stripe-token'] }
      rescue Recurly::Resource::Invalid, Recurly::API::ResponseError => e
        puts e
      ensure
        redirect back
      end
    end

    post '/api/transactions' do
      begin
        Recurly::Transaction.create!({
          account: {
            account_code: SecureRandom.uuid,
            billing_info: { token_id: params['stripe-token'] }
          },
          amount_in_cents: 999,
          currency: 'USD'
        })
      rescue Recurly::Resource::Invalid, Recurly::API::ResponseError => e
        puts e
      ensure
        redirect back
      end
    end

    put '/api/accounts/:account_code' do
      begin
        account = Recurly::Account.find params[:account_code]
        account.billing_info = { token_id: params['stripe-token'] }
        account.save!
      rescue Recurly::Resource::Invalid, Recurly::API::ResponseError => e
        puts e
      ensure
        redirect back
      end
    end

  end
end