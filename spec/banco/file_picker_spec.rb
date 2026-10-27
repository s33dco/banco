# frozen_string_literal: true

require 'banco/file_picker'

module Banco
  describe FilePicker do
    let(:stdin)  { instance_double(IO, gets: nil) }
    let(:stdout) { instance_double(IO, puts: nil, print: nil) }

    def with_input(text)
      allow(stdin).to receive(:gets).and_return(text)
    end

    describe '.pick' do
      context 'when no CSV files exist' do
        before { allow(Dir).to receive(:glob).with('*.csv').and_return([]) }

        it 'returns the path the user types' do
          with_input("custom.csv\n")
          expect(described_class.pick(stdin:, stdout:)).to eq('custom.csv')
        end

        it 'exits when the user types q' do
          with_input("q\n")
          expect { described_class.pick(stdin:, stdout:) }.to raise_error(SystemExit)
        end
      end

      context 'when one CSV file exists' do
        before { allow(Dir).to receive(:glob).with('*.csv').and_return(['statements.csv']) }

        it 'returns the found file when user presses Enter' do
          with_input("\n")
          expect(described_class.pick(stdin:, stdout:)).to eq('statements.csv')
        end

        it 'returns a custom path when the user types one' do
          with_input("other.csv\n")
          expect(described_class.pick(stdin:, stdout:)).to eq('other.csv')
        end
      end

      context 'when multiple CSV files exist' do
        let(:files) { ['april.csv', 'march.csv'] }

        before { allow(Dir).to receive(:glob).with('*.csv').and_return(files) }

        it 'returns the file selected by number' do
          with_input("2\n")
          expect(described_class.pick(stdin:, stdout:)).to eq('march.csv')
        end

        it 'returns a custom path when the user types a non-numeric path' do
          with_input("custom.csv\n")
          expect(described_class.pick(stdin:, stdout:)).to eq('custom.csv')
        end

        it 'exits when the user types q' do
          with_input("q\n")
          expect { described_class.pick(stdin:, stdout:) }.to raise_error(SystemExit)
        end
      end
    end
  end
end
