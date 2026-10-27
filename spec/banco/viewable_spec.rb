# frozen_string_literal: true

require 'bigdecimal'
require 'banco/reporter'
require 'banco/reader'

module Banco
  describe Viewable do
    before do
      reader = Reader.new('test.csv', 'test')
      reader.read_in_csv_data
      @reporter = Reporter.new('test.csv', 'test', reader.all_from_csv)
    end

    describe '#to_pounds' do
      it 'formats a BigDecimal as a right-aligned pounds string' do
        expect(@reporter.to_pounds(BigDecimal('12.34'))).to eq('£     12.34')
      end

      it 'truncates to 2 decimal places without rounding' do
        expect(@reporter.to_pounds(BigDecimal('9.999'))).to eq('£      9.99')
      end

      it 'formats zero correctly' do
        expect(@reporter.to_pounds(BigDecimal('0'))).to eq('£      0.00')
      end
    end

    describe '#dashes' do
      it 'returns a 55-character line of dashes' do
        expect(@reporter.dashes.length).to eq(55)
        expect(@reporter.dashes).to match(/\A-+\z/)
      end
    end

    describe '#date_range' do
      it 'returns a string showing last date to first date' do
        expect(@reporter.date_range).to eq('(21/09/17 - 21/09/17)')
      end
    end

    describe '#facts' do
      it 'includes the transaction count' do
        expect(@reporter.facts(@reporter.all_transactions)).to include('8 transactions')
      end
    end

    describe '#bottom_line' do
      it 'includes money in and money out headings' do
        result = @reporter.bottom_line
        expect(result).to include('Money In')
        expect(result).to include('Money Out')
      end

      it 'shows SURPLUS when incomings exceed outgoings' do
        expect(@reporter.bottom_line).to include('SURPLUS')
      end
    end

    describe '#transactions_all' do
      it 'includes all 8 transactions' do
        result = @reporter.transactions_all
        expect(result).to include('All transactions:')
        expect(result).to include('8 transactions')
      end
    end

    describe '#transactions_out' do
      it 'lists only outgoing transactions' do
        result = @reporter.transactions_out
        expect(result).to include('Outgoing Transactions:')
        expect(result).to include('4 transactions')
      end
    end

    describe '#transactions_in' do
      it 'lists only incoming transactions' do
        result = @reporter.transactions_in
        expect(result).to include('Incoming Transactions')
        expect(result).to include('4 transactions')
      end
    end

    describe '#money_out_summary' do
      it 'includes the outgoings summary header' do
        expect(@reporter.money_out_summary).to include('Outgoings Summary')
      end
    end

    describe '#money_in_summary' do
      it 'includes the incomings summary header' do
        expect(@reporter.money_in_summary).to include('Incomings Summary')
      end
    end
  end
end
