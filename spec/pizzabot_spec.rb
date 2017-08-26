require_relative '../lib/pizzabot.rb'
require_relative '../lib/string_input_parser.rb'
require_relative '../lib/location.rb'

describe Pizzabot do

  describe 'initialize' do
    subject { Pizzabot.new }

    context 'Without any values passed in' do
      specify { expect(subject.current_location.x).to be(0) }
      specify { expect(subject.current_location.y).to be(0) }
      specify { expect(subject.instructions).to eq([]) }
      specify { expect(subject.input_parser_class).to be(StringInputParser) }
      specify { expect(subject.path_optimizer_class).to be_nil }
    end

    context 'With a string input parser supplied' do
      let(:input_parser) { double(:input_parser) }
      subject { Pizzabot.new(input_parser_class: input_parser) }

      specify { expect(subject.input_parser_class).to eq(input_parser) }
    end

    context 'With a path optimizer class' do
      let(:path_optimizer) { double(:path_optimizer) }
      subject { Pizzabot.new(path_optimizer_class: path_optimizer) }

      specify { expect(subject.path_optimizer_class).to eq(path_optimizer) }
    end

    context 'With a current location' do
      let(:current_location) { Location.new(x: 1, y: 3) }
      subject { Pizzabot.new(current_location: current_location) }

      specify { expect(subject.current_location).to eq(current_location) }
    end
  end

  describe 'parse_input' do
    let(:input_parser) { double(:input_parser, parse: input_parser_results) }
    let(:input_parser_results) { double(:input_parser_results, locations: locations) }
    let(:locations) { [] }
    let(:input) { double(:input) }
    subject { Pizzabot.new(input_parser_class: input_parser) }

    it 'calls parse on the input parser' do
      expect(input_parser).to receive(:parse).with(input)

      subject.parse_input(input)
    end

    context 'when there are no location results' do
      it 'issues no instructions' do
        subject.parse_input(input)

        expect(subject.instructions).to eq([])
      end
    end

    context 'when there are location results' do
      let(:locations) { [Location.new(x: 2, y: 0), Location.new(x: 1, y: 4)] }

      it 'issues instructions to move there and drop the pizza' do
        subject.parse_input(input)

        expect(subject.instructions).to eq(['E', 'E', 'D', 'W', 'N', 'N', 'N', 'N', 'D'])
      end

      context 'when a path optimizer is passed in' do
        let(:origin_location) { Location.new }
        let(:reversed_locations) { locations.reverse }
        let(:path_optimizer) { double(:path_reverser, optimize: reversed_locations) }
        subject { Pizzabot.new(input_parser_class: input_parser,
                               path_optimizer_class: path_optimizer,
                               current_location: origin_location) }

        it 'calls the optimizer to optimize the paths' do
          expect(path_optimizer).to receive(:optimize).with(origin_location, locations)

          subject.parse_input(input)
        end

        it 'issues instructions to move there and drop the pizza' do
          subject.parse_input(input)

          expect(subject.instructions).to eq(['E', 'N', 'N', 'N', 'N', 'D', 'E', 'S', 'S', 'S', 'S', 'D'])
        end
      end
    end
  end

  describe 'perform_deliveries' do
    let(:locations) { [] }
    let!(:pizzabot){ Pizzabot.new() }
    before { pizzabot.perform_deliveries(locations) }

    context 'when there are no locations' do
      specify { expect(pizzabot.instructions).to eq([]) }
    end

    context 'when there are locations' do
      let(:locations) { [Location.new(x: 2, y: 0)] }

      specify { expect(pizzabot.instructions).to eq(['E', 'E', 'D']) }
    end

    context 'when two pizzas are going to the same location' do
      let(:locations) { [Location.new(x: 2, y: 0), Location.new(x: 2, y: 0)] }

      specify { expect(pizzabot.instructions).to eq(['E', 'E', 'D', 'D']) }
    end

    context 'when two pizzas are going to separate locations' do
      let(:locations) { [Location.new(x: 2, y: 0), Location.new(x: 3, y: 0)] }

      specify { expect(pizzabot.instructions).to eq(['E', 'E', 'D', 'E', 'D']) }

      context 'when a path optimizer is passed in' do
        let(:origin_location) { Location.new }
        let(:reversed_locations) { locations.reverse }
        let(:path_optimizer) { double(:path_reverser, optimize: reversed_locations) }
        let!(:pizzabot) { Pizzabot.new( path_optimizer_class: path_optimizer, current_location: origin_location) }

        it 'calls the optimizer to optimize the paths' do
          expect(path_optimizer).to have_received(:optimize).with(origin_location, locations)
        end

        it 'issues instructions to move there and drop the pizza' do
          expect(pizzabot.instructions).to eq(['E', 'E', 'E', 'D', 'W', 'D'])
        end
      end
    end
  end
end
