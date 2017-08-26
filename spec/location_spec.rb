require_relative '../lib/location.rb'

describe Location do
  describe 'Initialize' do
    context 'When given an x and a y' do
      let(:x) { 1 }
      let(:y) { 2 }
      subject(:location) { Location.new(x: x, y: y) }

      it 'sets the x attribute' do
        expect(location.x).to eql(x)
      end

      it 'sets the y attribute' do
        expect(location.y).to eql(y)
      end
    end
  end

  describe 'on_plane?' do
    context 'When given a location on a with an x coordinate' do
      let(:x) { 5 }
      subject(:location) { Location.new(x: x) }

      context 'and a y coordinate lower than its absolute value' do
        let(:x_dimension) { 3 }

        specify { expect(location.on_plane?(x_dimension, 0)).to be false }
      end

      context 'and a x coordinate higher than its absolute value' do
        let(:x_dimension) { 13 }

        specify { expect(location.on_plane?(x_dimension, 0)).to be true }
      end

      context 'and a x coordinate equal to its absolute value' do
        let(:x_dimension) { 5 }

        specify { expect(location.on_plane?(x_dimension, 0)).to be true }
      end
    end

    context 'When given a location on a with a y coordinate' do
      let(:y) { -10 }
      let(:location) { Location.new(y: y) }

      context 'and a y coordinate lower than its absolute value' do
        let(:y_dimension) { 8 }

        specify { expect(location.on_plane?(0, y_dimension)).to be false }
      end

      context 'and a y coordinate higher than its absolute value' do
        let(:y_dimension) { 11 }

        specify { expect(location.on_plane?(0, y_dimension)).to be true }
      end

      context 'and a y coordinate equal to its absolute value' do
        let(:y_dimension) { 10 }

        specify { expect(location.on_plane?(0, y_dimension)).to be true }
      end
    end
  end
end
