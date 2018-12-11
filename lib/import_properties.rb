# frozen_string_literal: true

class ImportProperties
  include Singleton
  include HTTParty
  base_uri 'http://landregistry.data.gov.uk'

  def perform
    csv.each do |row|
      Property.create_from_csv_row(row)
    end
  end

  def csv
    CSV.parse(response.body)
  end

  def response
    self.class.get('/app/ppd/ppd_data.csv', query: query)
  end

  def query # rubocop:disable Metrics/MethodLength
    {
      district: 'Southwark',
      et: estate_types,
      header: 'true',
      limit: 'all',
      max_date: max_date,
      min_date: min_date,
      nb: %w[true false],
      ptype: property_types,
      tc: transaction_categories
    }
  end

  def max_date
    format_date(Time.zone.now)
  end

  def min_date
    format_date(Time.zone.now - 1.year)
  end

  def format_date(date)
    date.strftime('%e %B %Y').strip
  end

  def property_types
    [
      'lrcommon:detached',
      'lrcommon:semi-detached',
      'lrcommon:terraced',
      'lrcommon:flat-maisonette'
    ]
  end

  def estate_types
    ['lrcommon:freehold', 'lrcommon:leasehold']
  end

  def transaction_categories
    ['ppd:standardPricePaidTransaction', 'ppd:additionalPricePaidTransaction']
  end
end
