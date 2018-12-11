# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib', 'import_properties')

RSpec.describe ImportProperties, type: :model, stub_land_reg: true, stub_epc: true, stub_postcode: true do
  before do
    Timecop.freeze(Time.parse('01-01-2018'))
    ImportProperties.new('Southwark').perform
  end

  after { Timecop.return }

  it 'requests the correct url' do
    expect(WebMock).to have_requested(:get, /min_date=1%20January%202017/)
    expect(WebMock).to have_requested(:get, /max_date=1%20January%202018/)
  end

  it 'creates properties' do
    expect(Property.count).to eq(10)
  end
end
