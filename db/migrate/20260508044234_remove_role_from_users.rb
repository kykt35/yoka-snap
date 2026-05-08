class RemoveRoleFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :role, :string, null: false, default: "user"
  end
end
