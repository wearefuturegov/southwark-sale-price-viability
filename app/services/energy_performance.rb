# frozen_string_literal: true

class EnergyPerformance
  include HTTParty
  base_uri 'https://epc.opendatacommunities.org/'

  def initialize(paon, saon, postcode)
    @address = [saon, paon].join(' ')
    @postcode = postcode
  end

  def report
    return nil unless response.body.length.positive?
    return nil unless response['rows'].count.positive?

    response['rows'][0]
  end

  private

  def response
    @response ||= self.class.get('/api/v1/domestic/search', options)
  end

  def headers
    {
      'Authorization' => "Basic #{ENV['EPC_API_KEY']}",
      'Accept' => 'application/json'
    }
  end

  def query
    {
      'address' => @address,
      'postcode' => @postcode
    }
  end

  def options
    {
      query: query,
      headers: headers
    }
  end
end
