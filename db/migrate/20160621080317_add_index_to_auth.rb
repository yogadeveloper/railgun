class AddIndexToAuth < ActiveRecord::Migration
  def change
    add_foreign_key "authorizations", "users"
  end
end
