require 'bundler'
Bundler.require

require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/support'
require 'sinatra/partial'
# require 'pry'

require_relative 'helpers/init'

Bundler.setup :default
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)
$: << File.expand_path('../helpers', __FILE__)

require 'dotenv'
Dotenv.load

Recurly.subdomain = ENV['RECURLY_SUBDOMAIN']
Recurly.api_key = ENV['RECURLY_API_KEY']

module ChicagoLotManagement
  class App < Sinatra::Base
    register Sinatra::AssetPack
    register Sinatra::Partial
    helpers  Sinatra::HtmlHelpers
    helpers  Sinatra::CountryHelpers

    set :root, File.dirname(__FILE__)
    set :environment, ENV['RACK_ENV'].to_sym
    set :partial_template_engine, :slim

    configure do
      set :port, 9001
      set :public_folder, './public'
      set :views, Proc.new { File.join(root, 'app', 'views') }
      set :slim, pretty: true
    end

    Sass.load_paths << File.join(root, 'app', 'assets', 'stylesheets')

    assets {

      serve '/css', from: 'app/assets/stylesheets'

      css :application, '/application.css', [
        '/css/base.css',
        '/css/forms.css'
      ]

      css :advanced, '/advanced.css', [
        '/css/themes/form-base.css',
        '/css/themes/form-minimal.css',
        '/css/themes/form-advanced.css'
      ]

      css :advanced_desktop, '/advanced_desktop.css', [
        '/css/themes/form-base.css',
        '/css/themes/form-minimal.css',
        '/css/themes/form-advanced.css',
        '/css/themes/form-advanced-desktop.css'
      ]

      serve '/js', from: 'app/assets/javascripts'

      js :advanced_form, '/advanced_form.js', [
        '/js/common_form.js',
      ]

      serve '/images', from: 'app/assets/images'
    }

    get '/subscribe-advanced' do
      slim :advanced
    end

    post '/api/subscriptions/new' do
      binding.pry
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
