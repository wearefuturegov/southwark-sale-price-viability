# frozen_string_literal: true

class Property < ApplicationRecord
  acts_as_mappable default_units: :miles,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  after_create :fetch_latlng
  def nearby
    Property.within(1, origin: self).where.not(id: id)
  end

  private

  def fetch_latlng
    return nil if lat.present? && lng.present?

    response = Postcodes::IO.new.lookup(postcode)
    update_attributes(lat: response.latitude, lng: response.longitude)
  end
end
