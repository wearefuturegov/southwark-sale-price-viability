# frozen_string_literal: true

RSpec.configure do |config|
  config.before(stub_postcode: true) do
    stub_request(:get, %r{https:\/\/api\.postcodes\.io\/postcodes})
      .to_return(body: { result: { latitude: '51.501009', longitude: '-0.141588' } }.to_json)
  end

  config.before(stub_epc: true) do
    stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org\/api\/v1\/domestic\/search})
      .to_return(status: 200,
                 body: { rows: [{ 'total-floor-area' => 1_234_5 }] }.to_json,
                 headers: { content_type: 'application/json' })
  end

  config.before(stub_land_reg: true) do
    stub_request(:get, %r{http:\/\/landregistry\.data\.gov\.uk})
      .to_return(status: 200,
                 body: File.read(Rails.root.join('spec', 'fixtures', 'price_paid.csv')))
  end
end
