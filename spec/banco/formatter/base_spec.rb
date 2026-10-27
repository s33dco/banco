# frozen_string_literal: true

require 'banco/report'
require 'banco/formatter/base'
require 'banco/formatter/text'
require 'banco/formatter/json_formatter'
require 'banco/formatter/csv_formatter'

module Banco
  module Formatter
    describe Base do
      describe '.names' do
        it 'includes text, json, and csv' do
          expect(described_class.names).to include('text', 'json', 'csv')
        end
      end

      describe '.for_name' do
        it 'returns the Text formatter class for "text"' do
          expect(described_class.for_name('text')).to eq(Text)
        end

        it 'returns the JSONFormatter class for "json"' do
          expect(described_class.for_name('json')).to eq(JSONFormatter)
        end

        it 'returns the CsvFormatter class for "csv"' do
          expect(described_class.for_name('csv')).to eq(CsvFormatter)
        end

        it 'raises ArgumentError for an unknown format' do
          expect { described_class.for_name('xml') }.to raise_error(ArgumentError, /Unknown format/)
        end
      end

      describe '.format_name' do
        it 'raises NotImplementedError on #call for a bare subclass' do
          stub_class = Class.new(described_class)
          allow(stub_class).to receive(:name).and_return('Banco::Formatter::Stub')
          instance = stub_class.new(instance_double(Banco::Report, all_transactions: [], outgoings: {}, incomings: {}))
          expect { instance.call }.to raise_error(NotImplementedError)
        end
      end
    end
  end
end
