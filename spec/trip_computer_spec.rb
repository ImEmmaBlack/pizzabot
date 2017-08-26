require_relative '../lib/trip_computer.rb'
require_relative '../lib/location.rb'

describe TripComputer do
  describe 'Initialize' do
    let(:x1) { 5 }
    let(:y1) { 9 }
    let(:x2) { 7 }
    let(:y2) { -1 }
    let(:start_location) { Location.new(x: x1, y: y1) }
    let(:end_location) { Location.new(x: x2, y: y2) }
    subject(:trip_computer) { TripComputer.new(start_location, end_location) }

    it 'sets the x_difference attribute' do
      expect(trip_computer.x_difference).to eq(x2 - x1)
    end

    it 'sets the y_difference attribute' do
      expect(trip_computer.y_difference).to eq(y2 - y1)
    end
  end

  describe 'directions' do
    let(:x1) { 0 }
    let(:y1) { 0 }
    let(:x2) { 0 }
    let(:y2) { 0 }
    let(:start_location) { Location.new(x: x1, y: y1) }
    let(:end_location) { Location.new(x: x2, y: y2) }
    subject(:directions) { TripComputer.new(start_location, end_location).directions }

    context 'when the x_difference is positive' do
      let(:x2) { 5 } 

      it 'returns the letter E the distance number of times' do
        expect(directions).to eq(Array.new((x2-x1), 'E'))
      end
    end

    context 'when the x_difference is negative' do
      let(:x2) { -5 } 

      it 'returns the letter W the distance number of times' do
        expect(directions).to eq(Array.new((x1-x2), 'W'))
      end
    end

    context 'when the y_difference is positive' do
      let(:y2) { 5 } 

      it 'returns the letter N the distance number of times' do
        expect(directions).to eq(Array.new((y2-y1), 'N'))
      end
    end

    context 'when the y_difference is negative' do
      let(:y2) { -5 } 

      it 'returns the letter S the distance number of times' do
        expect(directions).to eq(Array.new((y1-y2), 'S'))
      end
    end

    context 'when there is no difference' do
      it 'returns the an empty array' do
        expect(directions).to eq([])
      end
    end
  end
end
