class Location
  attr_reader :x, :y

  def initialize(x: 0, y: 0)
    @x = x
    @y = y
  end

  def on_plane?(x_dimensions, y_dimensions)
    @x.abs <= x_dimensions && @y.abs <= y_dimensions
  end
end

