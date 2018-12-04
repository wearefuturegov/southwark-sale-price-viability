# frozen_string_literal: true

class ApplicationController < ActionController::API

  def expected_range
    latlng = [params[:lat].to_f, params[:lng].to_f]
    render json: { expected: in_expected_range?(params[:sale_price].to_f, latlng) }
  end

  def in_expected_range?(sale_price, latlng)
    price_per_sq_mt = Property.average_price_for_area(latlng)
    price_estimate = price_per_sq_mt * params[:size].to_f
    range = Property.range_for_area(latlng) * params[:size].to_f
    sale_price < price_estimate - (range / 2) || sale_price < price_estimate + (range + 2)
  end

end
