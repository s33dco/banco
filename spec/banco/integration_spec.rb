# frozen_string_literal: true

require 'banco/parser'
require 'banco/grouper'
require 'banco/formatter/text'

module Banco
  describe 'integration: Parser → Grouper → Formatter::Text' do
    let(:fixture)      { File.expand_path('../fixtures/test.csv', __dir__) }
    let(:transactions) { Parser.new(fixture).parse }
    let(:report)       { Grouper.new(transactions).call }
    let(:formatter)    { Formatter::Text.new(report) }

    it 'loads 10 raw rows' do
      expect(transactions.size).to eq(10)
    end

    it 'strips blank-money rows, leaving 8 transactions' do
      expect(report.all_transactions.size).to eq(8)
    end

    it 'splits into 4 outgoing and 4 incoming' do
      expect(report.outgoing_trans.size).to eq(4)
      expect(report.incoming_trans.size).to eq(4)
    end

    it 'groups outgoings into 2 buckets' do
      expect(report.outgoings.size).to eq(2)
    end

    it 'groups incomings into 2 buckets' do
      expect(report.incomings.size).to eq(2)
    end

    it 'totals outgoing correctly (pence)' do
      expect(report.outgoing_total).to eq(16_046)
    end

    it 'totals incoming correctly (pence)' do
      expect(report.incoming_total).to eq(16_079)
    end

    it 'surplus is incoming minus outgoing (pence)' do
      expect(report.incoming_total - report.outgoing_total).to eq(33)
    end

    it 'date range spans the statement period' do
      expect(formatter.date_range).to eq('(21/09/17 - 21/09/17)')
    end

    it 'bottom_line output labels surplus' do
      expect(formatter.bottom_line).to include('SURPLUS')
    end

    it 'bottom_line shows both Money In and Money Out' do
      result = formatter.bottom_line
      expect(result).to include('Money In')
      expect(result).to include('Money Out')
    end
  end
end
