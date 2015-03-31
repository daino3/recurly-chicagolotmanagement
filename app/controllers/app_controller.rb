module ChicagoLotManagement
  class App < Sinatra::Base

    get '/subscribe' do
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
              token_id: params['recurly-token']
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
          billing_info: { token_id: params['recurly-token'] }
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
            billing_info: { token_id: params['recurly-token'] }
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
        account.billing_info = { token_id: params['recurly-token'] }
        account.save!
      rescue Recurly::Resource::Invalid, Recurly::API::ResponseError => e
        puts e
      ensure
        redirect back
      end
    end

  end
end