class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string, limit: 11
    add_column :users, :cnic, :string, limit: 13
    add_column :users, :address, :text
    add_column :users, :verification_code, :string
    add_column :users, :status, :boolean, default: false
  end
end
