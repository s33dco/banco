# frozen_string_literal: true

require 'bigdecimal'
require 'banco/transaction'

module Banco
  describe Transaction do
    before do
      @trans1 = described_class.new('12/01/17', 'some transaction', 'credit', '57.91', '0.00', '1')
      @trans2 = described_class.new('13/01/17', 'some other transaction', 'debit', '0.00', '57.91', '2')
    end

    it 'has a description string of 22 characters (upcase)' do
      expect(@trans2.description).to eq('SOME OTHER TRANSACTION')
      expect(@trans1.description).to eq('SOME TRANSACTION      ')
    end

    it 'truncates description longer than 22 characters' do
      long = described_class.new('12/01/17', 'A very long description that exceeds the limit', 'credit', '1.00', nil,
                                 '3')
      expect(long.description.length).to eq(22)
      expect(long.description).to eq('A VERY LONG DESCRIPTIO')
    end

    it 'handles nil type without raising' do
      expect { described_class.new('12/01/17', 'test', nil, '10.00', nil, '1') }.not_to raise_error
    end

    it 'has a type string upcased and 8 characters long' do
      expect(@trans2.type).to eq('DEBIT   ')
    end

    it 'has a date string' do
      expect(@trans1.date).to eq('12/01/17')
    end

    it 'has a row number' do
      expect(@trans2.csv_row_count).to eq('2')
    end

    it 'has a to_s of all date description type' do
      expect(@trans1.to_s).to eq('12/01/17 CREDIT   SOME TRANSACTION      ')
    end

    it 'converts nil moneyout to BigDecimal zero' do
      expect(@trans1.moneyout).to eq(BigDecimal('0'))
    end

    it 'converts nil moneyin to BigDecimal zero' do
      expect(@trans2.moneyin).to eq(BigDecimal('0'))
    end
  end
end
