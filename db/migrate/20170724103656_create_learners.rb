class CreateLearners < ActiveRecord::Migration
  def change
    create_table :learners do |t|
      t.integer :user_id
      t.string :name

      t.timestamps null: false
    end
  end
end
