class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.decimal :price
      t.string :status
      t.integer :frequency

      t.timestamps
    end
  end
end
