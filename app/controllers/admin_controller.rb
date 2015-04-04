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
  end
end