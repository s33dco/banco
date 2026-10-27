# frozen_string_literal: true

require 'bigdecimal'
require 'banco/reporter'
require 'banco/reader'
module Banco
  describe Reporter do
    before do
      @testreader = Banco::Reader.new('test.csv', 'test')
      @testreader.read_in_csv_data
      @tester = described_class.new('test.csv', 'test', @testreader.all_from_csv)
    end

    it 'has a GROUPING_PREFIX_LENGTH constant of 9' do
      expect(Reporter::GROUPING_PREFIX_LENGTH).to eq(9)
    end

    it 'does not mutate the transactions array passed to it' do
      reader = Banco::Reader.new('test.csv', 'test')
      reader.read_in_csv_data
      transactions = reader.all_from_csv
      original_size = transactions.size
      described_class.new('test.csv', 'test', transactions)
      expect(transactions.size).to eq(original_size)
    end

    it 'removes transactions with zero values (moneyin / moneyout)' do
      expect(@tester.all_transactions.size).to eq(8)
    end

    it 'produces an array of incoming transactions' do
      expect(@tester.incoming_trans.size).to eq(4)
    end

    it 'produces an array of outgoing transactions' do
      expect(@tester.outgoing_trans.size).to eq(4)
    end

    it 'produces a hash of outgoing transactions' do
      expect(@tester.outgoings.size).to eq(2)
    end

    it 'produces a hash of incoming transactions' do
      expect(@tester.incomings.size).to eq(2)
    end

    it 'sums incoming transactions by matching description string' do
      expect(@tester.incomings['INCOMING2']).to eq(BigDecimal('91.67'))
    end

    it 'sums outgoing transactions by matching description string' do
      expect(@tester.outgoings['OUTGOING2']).to eq(BigDecimal('91.34'))
    end

    it 'sums total incoming transactions' do
      expect(@tester.incoming_total).to eq(BigDecimal('160.79'))
    end

    it 'sums total outgoing transactions' do
      expect(@tester.outgoing_total).to eq(BigDecimal('160.46'))
    end
  end
end
