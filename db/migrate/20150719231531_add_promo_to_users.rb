class AddPromoToUsers < ActiveRecord::Migration
  def up
    add_column :users, :promo_code, :string
  end

  def down
    remove_column :users, :promo_code
  end
end
