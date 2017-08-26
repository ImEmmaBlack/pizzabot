require_relative 'location.rb'

class StringInputParser
  class ParserError < ArgumentError; end
  OFF_PLANE_ERROR = 'location is off grid!'
  NO_VALID_PLANE_ERROR = 'plane is missing or not valid!'
  attr_reader :locations, :x_dimensions, :y_dimensions, :errors

  def initialize(input)
    @errors = []
    set_plane(input)
    set_locations(input)
  end

  def self.parse(input)
    self.new(input).tap(&:validate!)
  end

  def validate!
    validate_plane
    validate_locations_on_plane if plane_is_valid?
    raise ParserError, @errors if @errors.any?
  end

  private

  def validate_plane
    @errors << NO_VALID_PLANE_ERROR if !plane_is_valid?
  end

  def validate_locations_on_plane
    @errors << OFF_PLANE_ERROR if !@locations.all? { |location| location.on_plane?(@x_dimensions, @y_dimensions) }
  end

  def set_plane(input)
    planeMatch = input[/\d+\s?x\s?\d+/]
    if planeMatch
      plane = planeMatch.split(/\s?x\s?/).map(&:to_i)
      @x_dimensions = plane[0]
      @y_dimensions = plane[1]
    end
  end

  def set_locations(input)
    locations_raw = input.scan(/-?\d+,\s?-?\d+/)
    @locations = parse_raw_locations(locations_raw)
  end

  def parse_raw_locations(locations_raw)
    locations_raw.map do |raw|
      coordinates = raw.split(/,\s?/).map(&:to_i)
      Location.new(x: coordinates[0], y: coordinates[1])
    end
  end

  def plane_is_valid?
    @x_dimensions && @y_dimensions
  end
end

