require 'yaml'

env = ChicagoLotManagement::App.environment.to_s

YAML.load_file("#{APP_ROOT}/config/stripe_secret.yml")[env].each do |key, value|
  ENV[key] = value
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']