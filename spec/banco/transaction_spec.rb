# frozen_string_literal: true

require 'banco/transaction'

module Banco
  describe Transaction do
    subject(:t) { described_class.from_row(['12/01/17', 'some transaction', 'credit', '57.91', nil]) }

    let(:debit_t) { described_class.from_row(['13/01/17', 'some other transaction', 'debit', nil, '57.91']) }

    it 'stores description upcased and padded to 22 characters' do
      expect(debit_t.description).to eq('SOME OTHER TRANSACTION')
      expect(t.description).to eq('SOME TRANSACTION      ')
    end

    it 'truncates description longer than 22 characters' do
      long = described_class.from_row(['12/01/17', 'A very long description that exceeds the limit', 'credit', '1.00',
                                       nil])
      expect(long.description.length).to eq(22)
      expect(long.description).to eq('A VERY LONG DESCRIPTIO')
    end

    it 'stores type upcased and padded to 8 characters' do
      expect(debit_t.type).to eq('DEBIT   ')
    end

    it 'handles nil type without raising' do
      expect { described_class.from_row(['12/01/17', 'test', nil, '10.00', nil]) }.not_to raise_error
    end

    it 'stores date string unchanged' do
      expect(t.date).to eq('12/01/17')
    end

    it 'converts money strings to integer pence' do
      expect(t.credit_pence).to eq(5791)
      expect(debit_t.debit_pence).to eq(5791)
    end

    it 'converts nil money to zero pence' do
      expect(t.debit_pence).to eq(0)
      expect(debit_t.credit_pence).to eq(0)
    end

    it 'converts empty string money to zero pence' do
      row_with_empty = described_class.from_row(['12/01/17', 'test', 'credit', '', ''])
      expect(row_with_empty.credit_pence).to eq(0)
      expect(row_with_empty.debit_pence).to eq(0)
    end

    it 'raises ArgumentError for a non-numeric money value' do
      expect { described_class.from_row(['12/01/17', 'test', 'credit', 'bad', nil]) }
        .to raise_error(ArgumentError, /Non-numeric/)
    end

    it 'has a to_s of date, type, description' do
      expect(t.to_s).to eq('12/01/17 CREDIT   SOME TRANSACTION      ')
    end

    it 'is frozen (Data.define immutability)' do
      expect(t).to be_frozen
    end
  end
end
