# frozen_string_literal: true
FactoryBot.define do
  factory :property do
    pao { 'MyString' }
    sao { 'MyString' }
    street { 'MyString' }
    locality { 'MyString' }
    town { 'MyString' }
    postcode { 'MyString' }
    lat { 51.501009 }
    lng { -0.141588 }
    price_paid { 1 }
    sq_mt { 1 }

    transient do
      source_property { nil }
    end

    trait :close_to do
      transient do
        location { RandomLocation.near_by(source_property.lat, source_property.lng, 160.93) }
      end
      lat { location[0] }
      lng { location[1] }
    end

    trait :far_away do
      lat { source_property.lng }
      lng { source_property.lat }
    end
  end
end
