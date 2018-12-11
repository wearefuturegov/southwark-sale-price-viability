# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#expected_range' do
    let(:property) { FactoryBot.create(:property, price_per_sq_mt: 4000) }
    let(:latlng) { RandomLocation.near_by(property.lat, property.lng, 160.93) }
    let(:json) { JSON.parse(response.body) }

    before do
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 3200, source_property: property)
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 3000, source_property: property)
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 4250, source_property: property)
      FactoryBot.create(:property, :far_away, price_per_sq_mt: 7000, source_property: property)
      FactoryBot.create(:property, :far_away, price_per_sq_mt: 9000, source_property: property)
    end

    it 'returns true if expected price is in the range' do
      get :expected_range, params: { lat: latlng[0], lng: latlng[1], sale_price: 4_000_000, size: 1000 }
      expect(json['expected']).to eq(true)
    end

    it 'returns false if expected price is not in the range' do
      get :expected_range, params: { lat: latlng[0], lng: latlng[1], sale_price: 10_000_000, size: 1000 }
      expect(json['expected']).to eq(false)
    end
  end
end
