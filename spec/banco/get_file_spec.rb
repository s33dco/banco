# frozen_string_literal: true

require 'banco/get_file'

module Banco
  describe GetFile do
    let(:instance) { described_class.allocate }

    describe '#file_checker_cleaner' do
      it 'accepts a filename ending in .csv' do
        expect { instance.file_checker_cleaner('statements.csv') }.not_to raise_error
      end

      it 'raises ArgumentError for a filename without a .csv extension' do
        expect { instance.file_checker_cleaner('statements.txt') }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError for a filename with no extension' do
        expect { instance.file_checker_cleaner('statements') }.to raise_error(ArgumentError)
      end
    end
  end
end
