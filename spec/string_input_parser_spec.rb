require_relative '../lib/string_input_parser.rb'

describe StringInputParser do
  describe 'self.parse' do

    describe 'plane' do
      subject(:parse) { StringInputParser.parse(input) }

      context 'when an input consists of the patern AxB' do
        let(:input) { "#{a}x#{b}" }

        context 'where A and B are numbers' do
          let(:a) { 1 }
          let(:b) { 2 }

          specify { expect(parse.x_dimensions).to eq(a) }
          specify { expect(parse.y_dimensions).to eq(b) }

          context 'and there is whitespace around the x' do
            let(:input) { "#{a} x #{b}" }

            specify { expect(parse.x_dimensions).to eq(a) }
            specify { expect(parse.y_dimensions).to eq(b) }
          end
        end

        context 'where A or B are not numbers' do
          let(:a) { 'a' }
          let(:b) { 2 }

          specify { expect { parse }.to raise_error(StringInputParser::ParserError) }
        end

        context 'where the pattern appears more than once' do
          let(:input) { "#{a}x#{b} #{c}x#{d}" }
          let(:a) { 1 }
          let(:b) { 2 }
          let(:c) { 3 }
          let(:d) { 4 }

          specify { expect(parse.x_dimensions).to eq(a) }
          specify { expect(parse.y_dimensions).to eq(b) }
        end
      end
    end

    describe 'locations' do
      subject(:locations) { StringInputParser.parse(full_input_string).locations }

      context 'given a valid plane' do
        let(:full_input_string) { "5x5 #{location_input}" }

        context 'when an input consists of the patern A,B' do
          let(:location_input) { "#{a},#{b}" }

          context 'where A and B are numbers' do
            context 'and they fall within the plane' do
              let(:a) { 1 }
              let(:b) { 2 }

              specify { expect(locations.count).to eq(1) }
              specify { expect(locations.first.x).to eq(a) }
              specify { expect(locations.first.y).to eq(b) }

              context 'and there is whitespace after the ,' do
                let(:location_input) { "#{a}, #{b}" }

                specify { expect(locations.count).to eq(1) }
                specify { expect(locations.first.x).to eq(a) }
                specify { expect(locations.first.y).to eq(b) }
              end

              context 'and they are surrounded in parenthasis' do
                let(:location_input) { "(#{a}, #{b})" }

                specify { expect(locations.count).to eq(1) }
                specify { expect(locations.first.x).to eq(a) }
                specify { expect(locations.first.y).to eq(b) }
              end

              context 'and they are negative' do
                let(:location_input) { "-#{a}, -#{b}" }

                specify { expect(locations.count).to eq(1) }
                specify { expect(locations.first.x).to eq(a * -1) }
                specify { expect(locations.first.y).to eq(b * -1) }
              end
            end

            context 'and they fall outside of the plane' do
              subject(:parse) { StringInputParser.parse(full_input_string) }
              let(:a) { 6 }
              let(:b) { 7 }

              specify { expect { parse }.to raise_error(StringInputParser::ParserError) }
            end
          end

          context 'where A or B are not numbers' do
            let(:a) { 'a' }
            let(:b) { 2 }

            specify { expect(locations.count).to eq(0) }
          end

          context 'where the pattern appears more than once' do
            let(:location_input) { "#{a},#{b} (#{c},#{d})" }
            let(:a) { 1 }
            let(:b) { 2 }
            let(:c) { 3 }
            let(:d) { 4 }

            specify { expect(locations.count).to eq(2) }
            specify { expect(locations.first.x).to eq(a) }
            specify { expect(locations.first.y).to eq(b) }
            specify { expect(locations.last.x).to eq(c) }
            specify { expect(locations.last.y).to eq(d) }
          end
        end
      end

      context 'given an invalid plane with good location coords' do
        let(:full_input_string) { '5x (1,2)' }
        subject(:parse) { StringInputParser.parse(full_input_string) }

        specify { expect { parse }.to raise_error(StringInputParser::ParserError) }
      end
    end
  end
end
