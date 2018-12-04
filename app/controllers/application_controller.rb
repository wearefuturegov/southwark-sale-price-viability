# frozen_string_literal: true

class ApplicationController < ActionController::API
  def expected_range
    latlng = [params[:lat].to_f, params[:lng].to_f]
    render json: { expected: in_expected_range?(params[:sale_price].to_f, params[:size].to_f, latlng) }
  end

  def in_expected_range?(sale_price, size, latlng)
    properties = Property.properties_within(latlng)
    max_price = properties.maximum(:price_per_sq_mt) * size
    min_price = properties.minimum(:price_per_sq_mt) * size
    sale_price.between?(min_price + (min_price * 0.05), max_price + (max_price * 0.05))
  end
end
