class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :sf_contact_id
      t.string :email
      t.timestamps null: false
    end
  end
end
