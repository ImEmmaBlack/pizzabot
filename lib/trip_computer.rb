class TripComputer
  NORTH = 'N'
  EAST = 'E'
  SOUTH = 'S'
  WEST = 'W'
  attr_reader :x_difference, :y_difference

  def initialize(start_location, end_location)
    @x_difference = end_location.x - start_location.x
    @y_difference = end_location.y - start_location.y
  end

  def directions
    ('' + x_instructions + y_instructions).split('')
  end

  private

  def x_instructions
    x_direction * @x_difference.abs
  end

  def y_instructions
    y_direction * @y_difference.abs
  end

  def y_direction
    @y_difference >= 0 ? NORTH : SOUTH
  end

  def x_direction
    @x_difference >= 0 ? EAST : WEST
  end
end

