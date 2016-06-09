class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :votable_id
      t.integer :votable_type
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
