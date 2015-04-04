module ChicagoLotManagement
  class App < Sinatra::Base

    helpers do
      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ["username","password"]
      end

      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Oops... we need your login name & password\n"])
        end
      end
    end

    get '/admin' do
      protected!
      @properties = Property.includes(:user).order("users.email ASC", "properties.subscription_id ASC")
      slim :admin, layout: true
    end

    delete '/property/:id' do
      property = Property.find(params[:id])
      Property.find(params[:id]).destroy
    end

    before "*" do
      @plans = Stripe::Plan.all.each_with_index.map{ |plan, index| [plan.id, index + 1] }
    end

    get '/' do
      slim :index, layout: true
    end

    get '/add-property' do
      @property_count = params[:count].to_i
      slim :'/_property', layout: false
    end

    get '/plan-data' do
      content_type :json

      @pricing = Stripe::Plan.all.data.inject({}) do |hash, obj|
        hash[obj.id] = obj.amount / 100; hash
      end.to_json
    end

    get '/subscribe-observation' do
      @plan = Stripe::Plan.retrieve("Observation")
      slim :form, layout: true
    end

    get '/subscribe-basic' do
      @plan = Stripe::Plan.retrieve("Basic")
      slim :form, layout: true
    end

    get '/subscribe-premium' do
      @plan = Stripe::Plan.retrieve("premium")
      slim :form, layout: true
    end

    post '/api/subscriptions/new' do
      begin
        account = params[:account].first
        user = User.find_or_create_by(email: account.delete(:email) )
        user.update_attributes(account)

        params[:properties].each do |property|
          binding.pry
          Property.create(property.merge(user: user))
        end
      rescue  ActiveRecord::Error => e
        puts e.message
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