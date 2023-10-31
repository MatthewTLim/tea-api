class AddCustomerToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_reference :subscriptions, :customer, null: false, foreign_key: true
  end
end
