class Histogram
  def initialize(values)
    @ranges = []
    @histogram = {}
    @values = values
    set_variables
  end

  def results
    @values.each do |p|
      @ranges.each do |r|
        @histogram[r] = @histogram[r] + 1 if r.include? p
      end
    end
    @histogram
  end

  def set_variables
    20.times.each do |i|
      bottom = 1000 * i
      top = bottom + 1000
      range = (bottom + 1..top)
      @histogram[range] = 0
      @ranges << range
    end
  end
end
