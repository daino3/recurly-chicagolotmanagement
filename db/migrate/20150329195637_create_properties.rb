class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.belongs_to :user
      t.string :address
      t.string :city
      t.string :nickname
      t.string :zip_code
      t.string :plan
    end
  end
end
