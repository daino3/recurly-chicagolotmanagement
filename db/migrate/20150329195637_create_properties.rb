class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.belongs_to :user
      t.string :address
      t.string :city, default: "Chicago"
      t.string :state, default: "Illinois"
      t.string :zip_code
      t.string :subscription_id
      t.string :subscription_type
    end
  end
end
