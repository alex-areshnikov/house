FactoryBot.define do
  factory :vehicle do
    name { "MyString" }
    vin { "MyString" }
    year { 1 }
    make { "MyString" }
    model { "MyString" }
    odometer { 1 }
  end
end
