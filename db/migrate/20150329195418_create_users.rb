class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :stripe_id
      t.string :stripe_token
      t.string :company
      t.string :phone_number
    end
  end
end
