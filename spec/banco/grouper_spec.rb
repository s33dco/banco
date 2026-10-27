# frozen_string_literal: true

require 'banco/grouper'
require 'banco/transaction'

module Banco
  describe Grouper do
    let(:fixture) { File.expand_path('../fixtures/test.csv', __dir__) }

    let(:transactions) do
      require 'csv'
      CSV.read(fixture).map { |row| Transaction.from_row(row) }
    end

    subject(:report) { described_class.new(transactions).call }

    it 'returns a Report' do
      expect(report).to be_a(Report)
    end

    it 'strips zero-pence rows, leaving 8 transactions' do
      expect(report.all_transactions.size).to eq(8)
    end

    it 'partitions into 4 outgoing and 4 incoming' do
      expect(report.outgoing_trans.size).to eq(4)
      expect(report.incoming_trans.size).to eq(4)
    end

    it 'groups outgoings into 2 buckets' do
      expect(report.outgoings.size).to eq(2)
    end

    it 'groups incomings into 2 buckets' do
      expect(report.incomings.size).to eq(2)
    end

    it 'sums outgoings by description prefix (in pence)' do
      expect(report.outgoings['OUTGOING2']).to eq(9134)
    end

    it 'sums incomings by description prefix (in pence)' do
      expect(report.incomings['INCOMING2']).to eq(9167)
    end

    it 'totals outgoing pence' do
      expect(report.outgoing_total).to eq(16_046)
    end

    it 'totals incoming pence' do
      expect(report.incoming_total).to eq(16_079)
    end

    it 'does not mutate the transactions array' do
      original_size = transactions.size
      described_class.new(transactions).call
      expect(transactions.size).to eq(original_size)
    end

    context 'with a custom prefix_length' do
      subject(:report) { described_class.new(transactions, prefix_length: 5).call }

      it 'groups by the given prefix length' do
        expect(report.outgoings.keys.all? { |k| k.length <= 5 }).to be true
      end
    end

    context 'with date filtering (multi_date.csv)' do
      require 'date'
      let(:multi_fixture) { File.expand_path('../fixtures/multi_date.csv', __dir__) }

      let(:multi_txns) do
        require 'csv'
        CSV.read(multi_fixture).map { |row| Transaction.from_row(row) }
      end

      it 'returns all 10 rows without a filter' do
        report = described_class.new(multi_txns).call
        expect(report.all_transactions.size).to eq(10)
      end

      it 'filters to September rows only with to: Sep 30' do
        report = described_class.new(multi_txns, to: Date.new(2017, 9, 30)).call
        expect(report.all_transactions.size).to eq(5)
      end

      it 'filters to October rows only with from: Oct 1' do
        report = described_class.new(multi_txns, from: Date.new(2017, 10, 1)).call
        expect(report.all_transactions.size).to eq(5)
      end

      it 'totals September outgoings correctly' do
        report = described_class.new(multi_txns, to: Date.new(2017, 9, 30)).call
        expect(report.outgoing_total).to eq(100_887)
      end

      it 'totals September incoming correctly' do
        report = described_class.new(multi_txns, to: Date.new(2017, 9, 30)).call
        expect(report.incoming_total).to eq(150_000)
      end
    end
  end
end
