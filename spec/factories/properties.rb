# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    pao { 'MyString' }
    sao { 'MyString' }
    street { 'MyString' }
    locality { 'MyString' }
    town { 'MyString' }
    postcode { 'MyString' }
    latlng { '' }
    price_paid { 1 }
    sq_mt { 1 }
  end
end
