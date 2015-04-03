require 'yaml'

env = ChicagoLotManagement::App.environment.to_s

development_file = "#{APP_ROOT}/config/stripe_secret.yml"

if File.exists?(development_file)
  YAML.load_file(development_file)[env].each do |key, value|
    ENV[key] = value
  end
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']