FactoryBot.define do
  factory :tea do
    title { "#{Faker::Hipster.word.capitalize} Tea" }
    description { Faker::Hipster.paragraph }
    temperature { Faker::Number.between(from: 70, to: 100) }
    brew_time { Faker::Number.between(from: 20, to: 120) }
  end
end
