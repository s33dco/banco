# frozen_string_literal: true

require 'banco/bank_format'

module Banco
  describe BankFormat do
    describe '.names' do
      it 'includes the three built-in formats' do
        expect(described_class.names).to include(:legacy, :split_columns, :signed_amount)
      end
    end

    describe '.[]' do
      it 'returns the named format object' do
        expect(described_class[:legacy]).to be_a(described_class)
      end

      it 'raises ArgumentError for an unknown format name' do
        expect { described_class[:unknown] }.to raise_error(ArgumentError, /Unknown bank format/)
      end
    end

    describe '.define' do
      it 'registers a new format accessible by name' do
        described_class.define(:spec_custom) do
          date_column        0
          description_column 1
          credit_column      2
          debit_column       3
          date_format        '%Y-%m-%d'
        end
        expect(described_class.names).to include(:spec_custom)
      end

      it 'stores DSL values on the format object' do
        fmt = described_class[:spec_custom]
        expect(fmt.date_col).to eq(0)
        expect(fmt.date_fmt).to eq('%Y-%m-%d')
      end
    end

    describe ':legacy built-in' do
      subject(:fmt) { described_class[:legacy] }

      it 'maps date and description columns' do
        expect(fmt.date_col).to eq(0)
        expect(fmt.description_col).to eq(1)
      end

      it 'maps type and credit columns' do
        expect(fmt.type_col).to eq(2)
        expect(fmt.credit_col).to eq(3)
      end

      it 'maps the debit column' do
        expect(fmt.debit_col).to eq(4)
      end

      it 'has the correct date format string' do
        expect(fmt.date_fmt).to eq('%d/%m/%y')
      end
    end

    describe ':split_columns built-in' do
      subject(:fmt) { described_class[:split_columns] }

      it 'maps credit and debit to separate columns' do
        expect(fmt.credit_col).to eq(3)
        expect(fmt.debit_col).to eq(4)
      end

      it 'uses a 4-digit year date format' do
        expect(fmt.date_fmt).to eq('%d/%m/%Y')
      end
    end

    describe ':signed_amount built-in' do
      subject(:fmt) { described_class[:signed_amount] }

      it 'has no type column' do
        expect(fmt.type_col).to be_nil
      end

      it 'maps credit and debit to the same column' do
        expect(fmt.credit_col).to eq(fmt.debit_col)
      end
    end
  end
end
