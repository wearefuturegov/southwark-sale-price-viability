# frozen_string_literal: true

class ApplicationController < ActionController::API
  def expected_range
    @properties = Property.where.not(price_per_sq_mt: nil).within_area([params[:lat].to_f, params[:lng].to_f])
    render json: json_response
  end

  private

  def json_response
    {
      expected: in_expected_range?(params[:sale_price].to_f, params[:size].to_f),
      max_price_per_sq_mt: max_price_per_sq_mt,
      min_price_per_sq_mt: min_price_per_sq_mt,
      properties: @properties.map(&:as_json),
      histogram: @properties.histogram
    }
  end

  def in_expected_range?(sale_price, size)
    max_price = max_price_per_sq_mt * size
    min_price = min_price_per_sq_mt * size
    sale_price.between?(min_price + (min_price * 0.05), max_price + (max_price * 0.05))
  end

  def max_price_per_sq_mt
    @properties.maximum(:price_per_sq_mt)
  end

  def min_price_per_sq_mt
    @properties.minimum(:price_per_sq_mt)
  end
end
