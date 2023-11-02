class ChangeSubscriptionPriceToFloat < ActiveRecord::Migration[7.0]
  def change
    change_column :subscriptions, :price, :float
  end
end
