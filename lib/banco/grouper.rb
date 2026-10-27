# frozen_string_literal: true

require 'banco/report'

module Banco
  class Grouper
    DEFAULT_PREFIX_LENGTH = 9

    def initialize(transactions, prefix_length: DEFAULT_PREFIX_LENGTH)
      @transactions = transactions
      @prefix_length = prefix_length
    end

    def call
      clean    = @transactions.reject { |t| t.credit_pence.zero? && t.debit_pence.zero? }
      out, inc = clean.partition { |t| t.credit_pence.zero? && t.debit_pence.positive? }
      Report.new(
        all_transactions: clean,
        outgoing_trans: out,
        incoming_trans: inc,
        outgoings: group(out, :debit_pence),
        incomings: group(inc, :credit_pence)
      )
    end

    private

    def group(transactions, attr)
      transactions.each_with_object(Hash.new(0)) do |t, h|
        h[t.description[0, @prefix_length]] += t.public_send(attr)
      end
    end
  end
end
