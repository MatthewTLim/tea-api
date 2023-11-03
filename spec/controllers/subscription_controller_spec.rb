require 'rails_helper'

RSpec.describe Api::V0::SubscriptionsController, type: :controller do
  describe '#create' do
    before do
      @customer = Customer.create!(
        first_name: 'Morgan',
        last_name: 'Murphy',
        email: 'art_of_moss@gmail.com',
        address: '123 Main St, Austin, Texas'
      )

      @valid_params = {
        frequency: 1,
        customer_id: @customer.id
      }

      post :create, params: { customer_id: @customer.id, subscription: @valid_params }
    end

    it 'subscribes a customer with valid params' do
      expect(Subscription.count).to eq(1)
      expect(response).to have_http_status(:created)
    end

    it "sets the price using the frequency" do
      expect(Subscription.last.price).to eq(19.99)
    end

    it "sets the title using frequency" do
      expect(Subscription.last.title).to eq("1 month subscription")
    end

    it "sets the status to true when the subscription is valid" do
      expect(Subscription.last.status).to eq(true)
    end
  end

  describe "#create invalid params" do
    before do
      @customer = Customer.create!(
        first_name: 'Morgan',
        last_name: 'Murphy',
        email: 'art_of_moss@gmail.com',
        address: '123 Main St, Austin, Texas'
      )
    end

    xit "does not create a subscription with invalid params" do
      @invalid_params = {
        frequency: nil,
        customer_id: @customer.id
      }
      post :create, params: { customer_id: @customer.id, subscription: @invalid_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "#update" do
    before do
      @customer = Customer.create!(
        first_name: 'Morgan',
        last_name: 'Murphy',
        email: 'art_of_moss@gmail.com',
        address: '123 Main St, Austin, Texas'
      )

      @valid_params = {
        frequency: 1,
        customer_id: @customer.id
      }

      post :create, params: { customer_id: @customer.id, subscription: @valid_params }

      @subscription_id = @customer.subscriptions.first.id
    end

    it "sets the subscription status to false when the subscription is canceled" do
      patch :update, params: { customer_id: @customer.id, id: @subscription_id }

      cancelled_subscription = Subscription.find(@subscription_id)
      expect(cancelled_subscription.status).to eq(false)
    end
  end

  describe '#index' do
    it 'returns all of a customers subscriptions (active/nonactive)' do
      @customer = Customer.create!(
        first_name: 'Morgan',
        last_name: 'Murphy',
        email: 'art_of_moss@gmail.com',
        address: '123 Main St, Austin, Texas'
      )

      @active_subscription = Subscription.create!(
        title: 'Active Subscription',
        price: 19.99,
        status: true,
        frequency: 1,
        customer: @customer
      )

      @canceled_subscription = Subscription.create!(
        title: 'Canceled Subscription',
        price: 0,
        status: false,
        frequency: 6,
        customer: @customer
      )

      get :index, params: { customer_id: @customer.id}

      @subscriptions = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(@subscriptions.count).to eq(2)

      expect(@subscriptions[0]['title']).to eq('Active Subscription')
      expect(@subscriptions[0]['price']).to eq(19.99)
      expect(@subscriptions[0]['status']).to eq(true)
      expect(@subscriptions[0]['frequency']).to eq(1)

      expect(@subscriptions[1]['title']).to eq('Canceled Subscription')
      expect(@subscriptions[1]['price']).to eq(0)
      expect(@subscriptions[1]['status']).to eq(false)
      expect(@subscriptions[1]['frequency']).to eq(6)
    end
  end

  describe '#set_subscription_details' do
    it 'sets details for a 1-month subscription' do
      subscription = Subscription.new(frequency: 1)
      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_details)

      expect(subscription.price).to eq(19.99)
      expect(subscription.title).to eq('1 month subscription')
      expect(subscription.status).to be true
    end

    it 'sets details for a 3-month subscription' do
      subscription = Subscription.new(frequency: 3)
      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_details)

      expect(subscription.price).to eq(47.98)
      expect(subscription.title).to eq('3 month subscription')
      expect(subscription.status).to be true
    end

    it 'sets details for a 6-month subscription' do
      subscription = Subscription.new(frequency: 6)
      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_details)

      expect(subscription.price).to eq(86.95)
      expect(subscription.title).to eq('6 month subscription')
      expect(subscription.status).to be true
    end

    it 'sets details for a 12-month subscription' do
      subscription = Subscription.new(frequency: 12)
      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_details)

      expect(subscription.price).to eq(149.90)
      expect(subscription.title).to eq('12 month subscription')
      expect(subscription.status).to be true
    end
  end

  describe '#set_subscription_tea_quantity' do
    it 'sets the correct number of random teas for a 1 month subscription' do
      customer = create(:customer)
      subscription = create(:subscription, customer: customer, frequency: 1)

      create_list(:tea, 10)

      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_tea_quantity)

      expect(subscription.teas.count).to eq(3)
    end

    it 'sets the correct number of random teas for a 3 month subscription' do
      customer = create(:customer)
      subscription = create(:subscription, customer: customer, frequency: 3)

      create_list(:tea, 10)

      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_tea_quantity)

      expect(subscription.teas.count).to eq(9)
    end

    it 'sets the correct number of random teas for a 6 month subscription' do
      customer = create(:customer)
      subscription = create(:subscription, customer: customer, frequency: 6)

      create_list(:tea, 20)

      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_tea_quantity)

      expect(subscription.teas.count).to eq(18)
    end

    it 'sets the correct number of random teas for a 12 month subscription' do
      customer = create(:customer)
      subscription = create(:subscription, customer: customer, frequency: 12)

      create_list(:tea, 40)

      controller.instance_variable_set(:@subscription, subscription)
      controller.send(:set_subscription_tea_quantity)

      expect(subscription.teas.count).to eq(36)
    end
  end
end