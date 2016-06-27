class RemoveForeignKeyFromAuthorizatinos < ActiveRecord::Migration
  def change
    remove_foreign_key :authorizations, :users

  end
end
