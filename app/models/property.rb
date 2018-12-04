# frozen_string_literal: true

class Property < ApplicationRecord
  acts_as_mappable default_units: :miles,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  after_create :fetch_latlng, :fetch_sq_mt

  scope :average_price_for_area, ->(latlng) { within(1, origin: latlng).average(:price_per_sq_mt).to_f }

  def self.create_from_csv_row(row)
    create(
      pao: row[8],
      sao: row[7],
      street: row[9],
      locality: row[10],
      town: row[11],
      postcode: row[3],
      price_paid: row[1]
    )
  end

  def nearby
    Property.within(1, origin: self).where.not(id: id)
  end

  private

  def fetch_latlng
    return nil if lat.present? && lng.present?

    response = Postcodes::IO.new.lookup(postcode)
    update_attributes(lat: response.latitude, lng: response.longitude) unless response.nil?
  end

  def fetch_sq_mt
    return nil if sq_mt.present?

    response = EnergyPerformance.new(pao, sao, postcode).report

    return nil if response.nil?

    update_attributes(
      sq_mt: response['total-floor-area'],
      price_per_sq_mt: (price_paid / response['total-floor-area'])
    )
  end
end
