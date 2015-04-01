module ChicagoLotManagement
  class App < Sinatra::Base
    register Sinatra::AssetPack
    register Sinatra::Partial
    helpers  Sinatra::HtmlHelpers
    helpers  Sinatra::CountryHelpers

    set :root, APP_ROOT
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
        '/css/themes/form-advanced.css',
        '/css/forms.scss'
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
        '/js/minimal_form.js',
        '/js/jquery.payment.js'
      ]

      serve '/images', from: 'app/assets/images'
    }
  end
end

# Run initializers
Dir[APP_ROOT.join('config', 'initializers', '**', '*.rb')].each { |file| require file }

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')