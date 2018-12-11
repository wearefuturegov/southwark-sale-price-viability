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

  context 'fetch_latlng', :stub_postcode do
    let(:property) { FactoryBot.create(:property, postcode: 'SW1A1AA', lat: nil, lng: nil) }

    it 'fetches the latlng' do
      property.reload
      expect(property.lat).to eq(51.501009)
      expect(property.lng).to eq(-0.141588)
    end
  end

  context 'fetch_sq_mt', :stub_epc do
    let(:property) { FactoryBot.create(:property, sq_mt: nil, price_paid: 1_234_50) }

    it 'fetches the property size' do
      property.reload
      expect(property.sq_mt).to eq(1_234_5)
    end

    it 'sets the price per square metres' do
      property.reload
      expect(property.price_per_sq_mt).to eq(10)
    end

    context 'if area is not specified' do
      before do
        stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org\/api\/v1\/domestic\/search})
          .to_return(status: 200,
                     body: { rows: [{ 'total-floor-area' => nil }] }.to_json,
                     headers: { content_type: 'application/json' })
      end

      it 'does not set values' do
        property.reload
        expect(property.sq_mt).to eq(nil)
        expect(property.price_per_sq_mt).to eq(nil)
      end
    end
  end

  context '#create_from_csv_row', :stub_postcode, :stub_epc do
    let(:csv_row) do
      [
        '773788C3-3E9D-2CE4-E053-6C04A8C05E57',
        '410000',
        '2018-06-25',
        'NW9 4AD',
        'F',
        'Y',
        'L',
        'FLAT 1',
        '35',
        'COXWELL BOULEVARD',
        '',
        'LONDON',
        'SOUTHWARK',
        'GREATER LONDON',
        'A',
        'http://landregistry.data.gov.uk/data/ppi/transaction/773788C3-3E9D-2CE4-E053-6C04A8C05E57/current'
      ]
    end

    let(:property) { Property.create_from_csv_row(csv_row) }

    it 'creates when given a CSV row' do
      expect(property.sao).to eq('FLAT 1')
      expect(property.pao).to eq('35')
      expect(property.street).to eq('COXWELL BOULEVARD')
      expect(property.locality).to eq('')
      expect(property.town).to eq('LONDON')
      expect(property.postcode).to eq('NW9 4AD')
    end
  end

  context 'statistics' do
    let(:property) { FactoryBot.create(:property, price_per_sq_mt: 4000) }
    let(:latlng) { [property.lat, property.lng] }

    before do
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 3200, source_property: property)
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 3000, source_property: property)
      FactoryBot.create(:property, :close_to, price_per_sq_mt: 4250, source_property: property)
      FactoryBot.create(:property, :far_away, price_per_sq_mt: 7000, source_property: property)
      FactoryBot.create(:property, :far_away, price_per_sq_mt: 9000, source_property: property)
    end

    describe '#average_price_for_area' do
      it 'gets an average' do
        expect(Property.average_price_for_area(latlng)).to eq(3612.5)
      end
    end

    context '#range_for_area' do
      it 'gets the range' do
        expect(Property.range_for_area(latlng)).to eq(1250)
      end
    end

    context '#histogram' do
      it 'generates a histogram' do
        histogram = Property.histogram
        expect(histogram[2001..3000]).to eq(1)
        expect(histogram[3001..4000]).to eq(2)
        expect(histogram[6001..7000]).to eq(1)
        expect(histogram[8001..9000]).to eq(1)
      end
    end
  end
end
