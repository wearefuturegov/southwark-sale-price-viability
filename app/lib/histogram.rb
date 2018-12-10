# frozen_string_literal: true

class Histogram
  def initialize(values, num_bins = 20, bin_step = 1000)
    @ranges = []
    @histogram = {}
    @values = values
    set_variables(num_bins, bin_step)
  end

  def results
    @values.each do |p|
      @ranges.each do |r|
        @histogram[r] = @histogram[r] + 1 if r.include? p
      end
    end
    @histogram
  end

  def set_variables(num_bins, bin_step)
    num_bins.times.each do |i|
      min = bin_step * i
      max = min + bin_step
      range = (min + 1..max)
      @histogram[range] = 0
      @ranges << range
    end
  end
end
