class AddPromoToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :promo_code, :string
  end
end
