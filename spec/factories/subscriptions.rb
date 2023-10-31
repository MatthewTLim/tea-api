FactoryBot.define do
  factory :subscription do
    frequency { [1, 3, 6, 12].sample }
    title { "#{frequency}-month-plan" }
    price do
      case frequency
      when 1
        19.99
      when 3
        47.98
      when 6
        86.95
      when 12
        149.90
      end
    end
    status { [true, false].sample }
  end
end
