FactoryBot.define do
  factory :play do
    title { Faker::Lorem.words(number: 3).join(" ") }
    date_range { Date.today..(Date.today + 1.month) }
  end
end
