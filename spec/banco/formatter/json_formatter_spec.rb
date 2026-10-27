# frozen_string_literal: true

require 'json'
require 'banco/formatter/json_formatter'
require 'banco/parser'
require 'banco/grouper'

module Banco
  module Formatter
    describe JSONFormatter do
      let(:fixture) { File.expand_path('../../fixtures/test.csv', __dir__) }
      let(:report)  { Grouper.new(Parser.new(fixture).parse).call }

      subject(:fmt) { described_class.new(report) }

      it 'has format_name "json"' do
        expect(described_class.format_name).to eq('json')
      end

      describe '#call' do
        it 'returns valid JSON' do
          expect { JSON.parse(fmt.call) }.not_to raise_error
        end

        it 'includes all 8 transactions' do
          data = JSON.parse(fmt.call)
          expect(data['transactions'].size).to eq(8)
        end

        it 'includes correct pence totals' do
          data = JSON.parse(fmt.call)
          expect(data['outgoing_total_pence']).to eq(16_046)
          expect(data['incoming_total_pence']).to eq(16_079)
        end

        it 'includes surplus_pence' do
          data = JSON.parse(fmt.call)
          expect(data['surplus_pence']).to eq(33)
        end
      end
    end
  end
end
