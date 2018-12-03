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
end
