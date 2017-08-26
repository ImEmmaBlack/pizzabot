require_relative 'location.rb'
require_relative 'string_input_parser.rb'
require_relative 'trip_computer.rb'

class Pizzabot
  DROP = 'D'
  attr_reader :current_location, :instructions, :input_parser_class, :path_optimizer_class

  def initialize(current_location: Location.new, input_parser_class: StringInputParser, path_optimizer_class: nil)
    @instructions = []
    @current_location = current_location # Location.new
    @input_parser_class = input_parser_class # args.fetch(:input_parser_class, StringInputParser)
    @path_optimizer_class = path_optimizer_class # args.fetch(:path_optimizer_class, nil)
  end

  def parse_input(input)
    parsed_input = @input_parser_class.parse(input)
    perform_deliveries(parsed_input.locations)
  end

  def perform_deliveries(locations)
    locations = @path_optimizer_class.optimize(@current_location, locations) if @path_optimizer_class
    locations.each { |location| deliver_to(location) }
  end

  private

  def deliver_to(location)
    move_to(location)
    drop_pizza
  end

  def move_to(location)
    @instructions += TripComputer.new(@current_location, location).directions
    @current_location = location
  end

  def drop_pizza
    @instructions << DROP
  end
end
