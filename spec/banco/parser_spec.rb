# frozen_string_literal: true

require 'banco/parser'

module Banco
  describe Parser do
    let(:fixture)      { File.expand_path('../fixtures/test.csv', __dir__) }
    let(:with_header)  { File.expand_path('../fixtures/with_header.csv', __dir__) }
    let(:bad_money)    { File.expand_path('../fixtures/bad_money.csv', __dir__) }

    describe '#parse' do
      it 'returns an array of Transaction objects' do
        result = described_class.new(fixture).parse
        expect(result).to all(be_a(Transaction))
      end

      it 'parses all 10 rows' do
        expect(described_class.new(fixture).parse.size).to eq(10)
      end

      it 'skips row 0 when skip_header: true' do
        expect(described_class.new(with_header, skip_header: true).parse.size).to eq(10)
      end

      it 'parses credit_pence as integer pence' do
        transactions = described_class.new(fixture).parse
        incoming = transactions.find { |t| t.credit_pence.positive? }
        expect(incoming.credit_pence).to eq(1234)
      end

      it 'parses debit_pence as integer pence' do
        transactions = described_class.new(fixture).parse
        outgoing = transactions.find { |t| t.debit_pence.positive? }
        expect(outgoing.debit_pence).to eq(1234)
      end

      it 'raises ArgumentError for a non-numeric money value' do
        expect { described_class.new(bad_money).parse }.to raise_error(ArgumentError, /Non-numeric/)
      end

      it 'raises ArgumentError when the file does not exist' do
        expect { described_class.new('no_such_file.csv').parse }.to raise_error(ArgumentError, /File not found/)
      end

      it 'accepts a bank_format: keyword and uses its column mapping' do
        fmt = BankFormat[:legacy]
        result = described_class.new(fixture, bank_format: fmt).parse
        expect(result).to all(be_a(Transaction))
      end
    end
  end
end
