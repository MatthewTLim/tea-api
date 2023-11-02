def calculate_subscription_price(duration)
  case duration
  when 1
    19.99
  when 3
    47.98
  when 6
    86.95
  when 12
    149.90
  else
    0.0
  end
end

100.times do
  Tea.create(
    title: "#{Faker::Hipster.word.capitalize} Tea",
    description: Faker::Hipster.paragraph,
    temperature: rand(70..100),
    brew_time: rand(20..120)
  )
end

20.times do
  customer = Customer.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address
  )

  subscription_duration = [1, 3, 6, 12].sample

  subscriptions = Subscription.create(
    title: "#{subscription_duration}-month subscription",
    price: calculate_subscription_price(subscription_duration),
    status: [true, false].sample,
    frequency: subscription_duration
  )

  case subscription_duration
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

  teas = Tea.all.sample(num_teas)

  teas.each do |tea|
    subscriptions.teas << tea
  end

  customer.subscriptions << subscriptions
end
