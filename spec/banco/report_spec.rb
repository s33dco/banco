# frozen_string_literal: true

require 'banco/report'
require 'banco/transaction'

module Banco
  describe Report do
    let(:t_in)  { Transaction.from_row(['01/01/17', 'Salary', 'credit', '1000.00', nil]) }
    let(:t_out) { Transaction.from_row(['01/01/17', 'Rent',   'debit',  nil, '800.00']) }

    subject(:report) do
      described_class.new(
        all_transactions: [t_in, t_out],
        outgoing_trans: [t_out],
        incoming_trans: [t_in],
        outgoings: { 'RENT     ' => 80_000 },
        incomings: { 'SALARY   ' => 100_000 }
      )
    end

    it 'computes outgoing_total from the outgoings hash' do
      expect(report.outgoing_total).to eq(80_000)
    end

    it 'computes incoming_total from the incomings hash' do
      expect(report.incoming_total).to eq(100_000)
    end

    it 'computes surplus_pence as incoming minus outgoing' do
      expect(report.surplus_pence).to eq(20_000)
    end

    it 'returns date_range as first and last transaction dates' do
      expect(report.date_range).to eq(['01/01/17', '01/01/17'])
    end

    it 'is frozen (Data.define immutability)' do
      expect(report).to be_frozen
    end
  end
end
