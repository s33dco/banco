# frozen_string_literal: true

require 'bigdecimal'
require 'banco/reader'
require 'banco/reporter'

module Banco
  describe 'integration: Reader → Reporter' do
    let(:fixture) { File.expand_path('../../fixtures/test.csv', __FILE__) }

    before do
      reader = Reader.new(fixture, 'integration test')
      reader.read_in_csv_data
      @report = Reporter.new(fixture, 'integration test', reader.all_from_csv)
    end

    it 'loads 10 raw rows' do
      reader = Reader.new(fixture, 'count check')
      reader.read_in_csv_data
      expect(reader.all_from_csv.length).to eq(10)
    end

    it 'strips blank-money rows, leaving 8 transactions' do
      expect(@report.all_transactions.size).to eq(8)
    end

    it 'splits into 4 outgoing and 4 incoming' do
      expect(@report.outgoing_trans.size).to eq(4)
      expect(@report.incoming_trans.size).to eq(4)
    end

    it 'groups outgoings into 2 buckets' do
      expect(@report.outgoings.size).to eq(2)
    end

    it 'groups incomings into 2 buckets' do
      expect(@report.incomings.size).to eq(2)
    end

    it 'totals outgoing correctly' do
      expect(@report.outgoing_total).to eq(BigDecimal('160.46'))
    end

    it 'totals incoming correctly' do
      expect(@report.incoming_total).to eq(BigDecimal('160.79'))
    end

    it 'surplus is incoming minus outgoing' do
      surplus = @report.incoming_total - @report.outgoing_total
      expect(surplus).to eq(BigDecimal('0.33'))
    end

    it 'date range spans the statement period' do
      expect(@report.date_range).to eq('(21/09/17 - 21/09/17)')
    end

    it 'bottom_line output labels surplus' do
      expect(@report.bottom_line).to include('SURPLUS')
    end

    it 'bottom_line shows both Money In and Money Out' do
      result = @report.bottom_line
      expect(result).to include('Money In')
      expect(result).to include('Money Out')
    end
  end
end
