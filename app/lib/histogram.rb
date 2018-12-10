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
      bottom = bin_step * i
      top = bottom + 1000
      range = (bottom + 1..top)
      @histogram[range] = 0
      @ranges << range
    end
  end
end
