class Api::V0::SubscriptionsController < ApplicationController
  def index
    @customer = Customer.find(params[:customer_id])
    @subscriptions = @customer.subscriptions
    render json: @subscriptions
  end

  def create
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

  def update
    @subscription = Subscription.find(params[:id])
    @subscription.update(status: false)
    render json: @subscription, status: :ok
  end

  private

  def subscription_params
    params.require(:subscription).permit(:frequency)
  end

  def set_subscription_details
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

  def set_subscription_tea_quantity
    case @subscription.frequency
    when 1
      num_teas = 3
    when 3
      num_teas = 9
    when 6
      num_teas = 18
    when 12
      num_teas = 36
    else
      num_teas = 0
    end

    @subscription.teas.clear

    num_teas.times do
      tea = Tea.all.sample
      @subscription.teas << tea
    end
  end
end