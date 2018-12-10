# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('app', 'lib', 'histogram')

RSpec.describe Histogram do
  let(:values) { [1000, 1200, 1500, 2100, 2500, 7050, 7100] }
  let(:results) { described_class.new(values).results }

  it 'returns the expected results' do
    expect(results[1..1000]).to eq(1)
    expect(results[1001..2000]).to eq(2)
    expect(results[2001..3000]).to eq(2)
    expect(results[3001..4000]).to eq(0)
    expect(results[7001..8000]).to eq(2)
  end
end
