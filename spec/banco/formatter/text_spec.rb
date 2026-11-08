# frozen_string_literal: true

require 'csv'
require 'tempfile'
require 'banco/formatter/text'
require 'banco/parser'
require 'banco/grouper'

module Banco
  module Formatter
    describe Text do
      let(:fixture)     { File.expand_path('../../fixtures/test.csv', __dir__) }
      let(:deficit_csv) { File.expand_path('../../fixtures/deficit.csv', __dir__) }
      let(:report)      { Grouper.new(Parser.new(fixture).parse).call }

      subject(:fmt)     { described_class.new(report) }

      it 'has format_name "text"' do
        expect(described_class.format_name).to eq('text')
      end

      describe '#call' do
        it 'delegates to bottom_line' do
          expect(fmt.call).to eq(fmt.bottom_line)
        end
      end

      describe '#dashes' do
        it 'returns a 55-character line of dashes' do
          expect(fmt.dashes.length).to eq(55)
          expect(fmt.dashes).to match(/\A-+\z/)
        end
      end

      describe '#date_range' do
        it 'returns last-to-first date with day count' do
          expect(fmt.date_range).to eq('(21/09/17 - 21/09/17) — 0 days')
        end
      end

      describe '#facts' do
        it 'includes the transaction count' do
          expect(fmt.facts(report.all_transactions)).to include('8 transactions')
        end
      end

      describe '#bottom_line' do
        it 'includes Money In and Money Out headings' do
          result = fmt.bottom_line
          expect(result).to include('Money In')
          expect(result).to include('Money Out')
        end

        it 'shows SURPLUS when incomings exceed outgoings' do
          expect(fmt.bottom_line).to include('SURPLUS')
        end

        it 'shows DEFICIT when outgoings exceed incomings' do
          def_report = Grouper.new(Parser.new(deficit_csv).parse).call
          expect(described_class.new(def_report).bottom_line).to include('DEFICIT')
        end
      end

      describe '#transactions_all' do
        it 'includes all transactions header and count' do
          result = fmt.transactions_all
          expect(result).to include('All transactions:')
          expect(result).to include('8 transactions')
        end
      end

      describe '#transactions_out' do
        it 'lists outgoing transactions with count' do
          result = fmt.transactions_out
          expect(result).to include('Outgoing Transactions:')
          expect(result).to include('4 transactions')
        end
      end

      describe '#transactions_in' do
        it 'lists incoming transactions with count' do
          result = fmt.transactions_in
          expect(result).to include('Incoming Transactions')
          expect(result).to include('4 transactions')
        end
      end

      describe '#money_out_summary' do
        it 'includes the outgoings summary header' do
          expect(fmt.money_out_summary).to include('Outgoings Summary')
        end
      end

      describe '#money_in_summary' do
        it 'includes the incomings summary header' do
          expect(fmt.money_in_summary).to include('Incomings Summary')
        end
      end

      describe '#menu' do
        it 'includes quit and all-transactions options' do
          m = fmt.menu
          expect(m).to include("'q' to quit")
          expect(m).to include("'a' to view all transactions")
        end

        it 'includes the load-new-file option' do
          expect(fmt.menu).to include("'l' to load a new file")
        end

        it 'includes the merge-another-file option' do
          expect(fmt.menu).to include("'+' to merge another file")
        end
      end

      describe '#save_summary_to_file' do
        it 'writes a CSV with Direction, Category, Total columns' do
          path = Tempfile.new(['summary', '.csv']).path
          fmt.save_summary_to_file(path)
          rows = CSV.read(path, headers: true)
          expect(rows.headers).to eq(%w[Direction Category Total])
        end

        it 'includes outgoing and incoming rows' do
          path = Tempfile.new(['summary', '.csv']).path
          fmt.save_summary_to_file(path)
          rows = CSV.read(path, headers: true)
          directions = rows.map { |r| r['Direction'] }.uniq.sort
          expect(directions).to eq(%w[Incoming Outgoing])
        end

        it 'writes totals as decimal strings' do
          path = Tempfile.new(['summary', '.csv']).path
          fmt.save_summary_to_file(path)
          rows = CSV.read(path, headers: true)
          expect(rows.first['Total']).to match(/\A\d+\.\d{2}\z/)
        end
      end

      describe '#save_transactions_to_file' do
        it 'writes a CSV with Date, Description, Amount columns' do
          path = Tempfile.new(['transactions', '.csv']).path
          fmt.save_transactions_to_file(path)
          rows = CSV.read(path, headers: true)
          expect(rows.headers).to eq(%w[Date Description Amount])
        end

        it 'writes one row per transaction' do
          path = Tempfile.new(['transactions', '.csv']).path
          fmt.save_transactions_to_file(path)
          rows = CSV.read(path, headers: true)
          expect(rows.size).to eq(report.all_transactions.size)
        end

        it 'writes negative amounts for outgoing transactions' do
          path = Tempfile.new(['transactions', '.csv']).path
          fmt.save_transactions_to_file(path)
          rows = CSV.read(path, headers: true)
          outgoing = rows.select { |r| r['Amount'].to_f.negative? }
          expect(outgoing).not_to be_empty
        end
      end
    end
  end
end
