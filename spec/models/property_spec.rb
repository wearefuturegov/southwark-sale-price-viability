# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:property) { FactoryBot.create(:property) }

  context 'nearby properties' do
    let!(:close_properties) { FactoryBot.create_list(:property, 7, :close_to, source_property: property) }
    let!(:far_away_properties) { FactoryBot.create_list(:property, 3, :far_away, source_property: property) }

    it 'finds nearby properties' do
      expect(property.nearby).to match_array(close_properties)
    end
  end

  context 'fetch_latlng' do
    before do
      stub_request(:get, 'https://api.postcodes.io/postcodes/SW1A1AA')
        .to_return(body: { result: { latitude: '51.501009', longitude: '-0.141588' } }.to_json)
    end

    let(:property) { FactoryBot.create(:property, postcode: 'SW1A1AA', lat: nil, lng: nil) }

    it 'fetches the latlng' do
      property.reload
      expect(property.lat).to eq(51.501009)
      expect(property.lng).to eq(-0.141588)
    end
  end

end
