FactoryBot.define do
  sequence :date_range do |n|
    Date.today + (n * 5).days..(Date.today + (n * 5 + 1).days)
  end

  factory :play do
    title { Faker::Lorem.words(number: 3).join(" ") }
    date_range { generate(:date_range) }
  end
end
