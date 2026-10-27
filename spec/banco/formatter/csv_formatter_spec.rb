# frozen_string_literal: true

require 'csv'
require 'banco/formatter/csv_formatter'
require 'banco/parser'
require 'banco/grouper'

module Banco
  module Formatter
    describe CsvFormatter do
      let(:fixture) { File.expand_path('../../fixtures/test.csv', __dir__) }
      let(:report)  { Grouper.new(Parser.new(fixture).parse).call }

      subject(:fmt) { described_class.new(report) }

      it 'has format_name "csv"' do
        expect(described_class.format_name).to eq('csv')
      end

      describe '#call' do
        it 'returns parseable CSV with a header row' do
          rows = CSV.parse(fmt.call)
          expect(rows.first).to eq(%w[date description type credit_pence debit_pence])
        end

        it 'has 9 rows: header plus 8 transactions' do
          rows = CSV.parse(fmt.call)
          expect(rows.size).to eq(9)
        end

        it 'contains integer pence values as strings' do
          rows = CSV.parse(fmt.call)
          credit_values = rows[1..].map { |r| r[3].to_i }
          expect(credit_values).to all(be_a(Integer))
        end
      end
    end
  end
end
