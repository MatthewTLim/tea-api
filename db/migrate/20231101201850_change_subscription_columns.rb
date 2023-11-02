class ChangeSubscriptionColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :subscriptions, :status, 'boolean USING CAST(status AS boolean)'
    change_column :subscriptions, :price, :integer
  end
end
