# frozen_string_literal: true

require 'banco/reporter'
require 'banco/reader'

module Banco
  describe Reporter do
    let(:test_csv) { File.expand_path('../fixtures/test.csv', __dir__) }

    before do
      reader = Reader.new(test_csv, 'test')
      reader.read_in_csv_data
      @tester = described_class.new(test_csv, 'test', reader.all_from_csv)
    end

    it 'has a GROUPING_PREFIX_LENGTH constant of 9' do
      expect(Reporter::GROUPING_PREFIX_LENGTH).to eq(9)
    end

    it 'does not mutate the transactions array passed to it' do
      reader = Banco::Reader.new(test_csv, 'test')
      reader.read_in_csv_data
      transactions = reader.all_from_csv
      original_size = transactions.size
      described_class.new(test_csv, 'test', transactions)
      expect(transactions.size).to eq(original_size)
    end

    it 'removes zero-pence rows, leaving 8 transactions' do
      expect(@tester.all_transactions.size).to eq(8)
    end

    it 'produces an array of 4 incoming transactions' do
      expect(@tester.incoming_trans.size).to eq(4)
    end

    it 'produces an array of 4 outgoing transactions' do
      expect(@tester.outgoing_trans.size).to eq(4)
    end

    it 'produces a hash of 2 outgoing buckets' do
      expect(@tester.outgoings.size).to eq(2)
    end

    it 'produces a hash of 2 incoming buckets' do
      expect(@tester.incomings.size).to eq(2)
    end

    it 'sums incoming transactions by description prefix (pence)' do
      expect(@tester.incomings['INCOMING2']).to eq(9167)
    end

    it 'sums outgoing transactions by description prefix (pence)' do
      expect(@tester.outgoings['OUTGOING2']).to eq(9134)
    end

    it 'sums total incoming (pence)' do
      expect(@tester.incoming_total).to eq(16_079)
    end

    it 'sums total outgoing (pence)' do
      expect(@tester.outgoing_total).to eq(16_046)
    end
  end
end
