require 'faker'

FactoryGirl.define do
  factory :example do
    a { Faker::Lorem.word }
    b { Faker::Lorem.word }
    c { Faker::Lorem.word }
  end
end
