# frozen_string_literal: true

class ApplicationController < ActionController::API
  def expected_range
    latlng = [params[:lat].to_f, params[:lng].to_f]
    render json: { expected: in_expected_range?(params[:sale_price].to_f, params[:size].to_f, latlng) }
  end

  def in_expected_range?(sale_price, size, latlng)
    price_estimate = Property.average_price_for_area(latlng) * size
    padding = (Property.range_for_area(latlng) * size / 2)
    sale_price < price_estimate - padding || sale_price < price_estimate + padding
  end
end
