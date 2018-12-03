# frozen_string_literal: true

class Property < ApplicationRecord
  acts_as_mappable default_units: :miles,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  def nearby
    Property.within(1, origin: self).where.not(id: id)
  end
end
