module ChicagoLotManagement
  class App < Sinatra::Base

    before "*" do
      @plans = Stripe::Plan.all.each_with_index.map{ |plan, index| [plan.id, index + 1] }
    end

    get '/' do
      slim :index, layout: true
    end

  end
end