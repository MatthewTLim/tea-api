# Read Me

# Tea Subscription Service

Welcome to the Tea Subscription Service, a web application for managing tea subscriptions for customers. This README provides an overview of the application, including its database schema, routing configuration, and key components.

## Table of Contents

1. [Database Schema](notion://www.notion.so/Tea-API-rubric-99c3f6341d88469684cb4f456b29fabd?p=ba4111e47ed34e2aa6d9bcb38a823584&showMoveTo=true#database-schema)
2. [Routing](notion://www.notion.so/Tea-API-rubric-99c3f6341d88469684cb4f456b29fabd?p=ba4111e47ed34e2aa6d9bcb38a823584&showMoveTo=true#routing)
3. [Subscriptions Controller](notion://www.notion.so/Tea-API-rubric-99c3f6341d88469684cb4f456b29fabd?p=ba4111e47ed34e2aa6d9bcb38a823584&showMoveTo=true#subscriptions-controller)

## Database Schema

The application's database schema is defined using ActiveRecord and includes the following tables:

- **customers:** Contains customer details, such as first name, last name, email, and address.
- **subscription_teas:** Represents the relationship between subscriptions and teas.
- **subscriptions:** Stores subscription information, including title, price, status, frequency, and the associated customer.
- **teas:** Holds information about teas, including title, description, temperature, and brew time.

Here is the ActiveRecord schema definition for the database:

```ruby
# db/schema.rb
ActiveRecord::Schema[7.0].define(version: 2023_11_01_202040) do
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_teas", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_subscription_teas_on_subscription_id"
    t.index ["tea_id"], name: "index_subscription_teas_on_tea_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "title"
    t.float "price"
    t.boolean "status"
    t.integer "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "temperature"
    t.integer "brew_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "subscription_teas", "subscriptions"
  add_foreign_key "subscription_teas", "teas"
  add_foreign_key "subscriptions", "customers"
end

```

## Routing

The application's routing is configured to define the following resources:

- **Customers:** A resource route for creating customers.
- **Subscriptions:** Nested within the customers resource, allowing the creation, retrieval (index), and deletion of subscriptions associated with a customer.

Here's the routing configuration defined in `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :customers, only: [:create] do
    resources :subscriptions, only: [:create, :index, :destroy]
  end
end

```

## Subscriptions Controller

The `SubscriptionsController` provides actions for managing subscriptions. It includes the following key methods:

- **`index`:** Retrieves all subscriptions associated with a customer and renders them as JSON.
- **`create`:** Creates a new subscription for a customer based on the provided parameters, calculates subscription details, and renders the customer's details as JSON on success or errors on failure.
- **`destroy`:** Marks a subscription as inactive by updating its status and renders the subscription details.

```ruby
class SubscriptionsController < ApplicationController
  def index
    # Retrieve subscriptions for a customer
    @customer = Customer.find(params[:customer_id])
    @subscriptions = @customer.subscriptions
    render json: @subscriptions
  end

  def create
    # Create a new subscription and set subscription details
    @customer = Customer.find(params[:customer_id])
    @subscription = Subscription.new(subscription_params)
    @subscription.customer = @customer
    set_subscription_details

    if @subscription.save
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # Mark a subscription as inactive
    @subscription = Subscription.find(params[:id])
    @subscription.update(status: false)
    render json: @subscription, status: :ok
  end

  private

  def subscription_params
    # Define permitted parameters for subscription creation
    params.require(:subscription).permit(:frequency)
  end

  def set_subscription_details
    # Set subscription details based on frequency
    # (e.g., title, price, and status)
    case @subscription.frequency
    when 1
      @subscription.price = 19.99
    when 3
      @subscription.price = 47.98
    when 6
      @subscription.price = 86.95
    when 12
      @subscription.price = 149.90
    end

    @subscription.title = "#{@subscription.frequency} month subscription"
    @subscription.status = true
  end
end

```