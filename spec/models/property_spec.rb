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

  context 'fetch_sq_mt' do
    before do
      stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org\/api\/v1\/domestic\/search}).
        to_return(status: 200,
                  body: { rows: [{ 'total-floor-area' => 1_234_5 }] }.to_json,
                  headers: { content_type: 'application/json' }
                 )
    end

    let(:property) { FactoryBot.create(:property, sq_mt: nil) }

    it 'fetches the property size' do
      property.reload
      expect(property.sq_mt).to eq(1_234_5)
    end
  end

end
