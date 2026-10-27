# frozen_string_literal: true

module Banco
  Report = Data.define(:all_transactions, :outgoing_trans, :incoming_trans, :outgoings, :incomings) do
    def outgoing_total = outgoings.values.sum
    def incoming_total = incomings.values.sum
    def surplus_pence  = incoming_total - outgoing_total
    def date_range     = [all_transactions.first&.date, all_transactions.last&.date]
  end
end
