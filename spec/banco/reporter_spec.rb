# frozen_string_literal: true

require 'bigdecimal'
require 'banco/reporter'
require 'banco/reader'
module Banco
  describe Reporter do
    before do
      @testreader = Banco::Reader.new('test.csv', 'test')
      @testreader.read_in_csv_data
      @tester = Banco::Reporter.new('test.csv', 'test', @testreader.all_from_csv)
    end

    it 'should remove transactions with zero values (moneyin / moneyout)' do
      expect(@tester.all_transactions.size).to eq(8)
    end

    it 'should produce an array of incoming transactions' do
      expect(@tester.incoming_trans.size).to eq(4)
    end

    it 'should produce an array of outgoing transactions' do
      expect(@tester.outgoing_trans.size).to eq(4)
    end

    it 'should produce a hash of outgoing transactions' do
      expect(@tester.outgoings.size).to eq(2)
    end

    it 'should produce a hash of incoming transactions' do
      expect(@tester.incomings.size).to eq(2)
    end

    it 'should sum incoming transactions by matching description string' do
      expect(@tester.incomings['INCOMING2']).to eq(BigDecimal('91.67'))
    end

    it 'should sum outgoing transactions by matching description string' do
      expect(@tester.outgoings['OUTGOING2']).to eq(BigDecimal('91.34'))
    end

    it 'should sum total incoming transactions' do
      expect(@tester.incoming_total).to eq(BigDecimal('160.79'))
    end

    it 'should sum total outgoing transactions' do
      expect(@tester.outgoing_total).to eq(BigDecimal('160.46'))
    end
  end
end
