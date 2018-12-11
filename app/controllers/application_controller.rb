# frozen_string_literal: true

class ApplicationController < ActionController::API
  def expected_range
    @properties = Property.where.not(price_per_sq_mt: nil).within_area([params[:lat].to_f, params[:lng].to_f])
    @histogram = @properties.histogram
    render json: json_response
  end

  private

  def json_response
    {
      expected: in_expected_range?(params[:sale_price].to_f, params[:size].to_f),
      max_price_per_sq_mt: max_price_per_sq_mt,
      min_price_per_sq_mt: min_price_per_sq_mt,
      properties: @properties.map(&:as_json),
      histogram: @histogram
    }
  end

  def in_expected_range?(sale_price, size)
    range = (min_price_per_sq_mt...max_price_per_sq_mt)
    price_per_sq_mt = sale_price.to_f / size.to_f
    range.include?(price_per_sq_mt)
  end

  def min_price_per_sq_mt
    trimmed_histogram.keys.first.first
  end

  def max_price_per_sq_mt
    trimmed_histogram.keys.last.last
  end

  def trimmed_histogram
    @trimmed_histogram ||= begin
      h = @histogram.dup
      h.each do |range, value|
        percentage = value.to_f / @properties.count
        h.delete(range) if percentage < 0.05
      end
      h
    end
  end
end
