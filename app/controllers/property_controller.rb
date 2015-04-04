module ChicagoLotManagement
  class App < Sinatra::Base

    delete '/property/:id' do
      property = Property.find(params[:id])
      Property.find(params[:id]).destroy
    end

    get '/add-property' do
      @property_count = params[:count].to_i
      slim :'/_property', layout: false
    end

  end
end