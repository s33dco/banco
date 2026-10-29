# frozen_string_literal: true

require 'banco/report'

module Banco
  class Grouper
    DEFAULT_PREFIX_LENGTH = 9

    def initialize(transactions, prefix_length: DEFAULT_PREFIX_LENGTH, from: nil, to: nil)
      @transactions = transactions
      @prefix_length = prefix_length
      @from = from
      @to = to
    end

    def call
      clean    = @transactions.reject { |t| t.credit_pence.zero? && t.debit_pence.zero? }
      clean    = filter_by_date(clean)
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

    def filter_by_date(transactions)
      return transactions if @from.nil? && @to.nil?

      transactions.select { |t| in_range?(t) }
    end

    def in_range?(transaction)
      return false if transaction.parsed_date.nil?

      (@from.nil? || transaction.parsed_date >= @from) &&
        (@to.nil? || transaction.parsed_date <= @to)
    end

    def group(transactions, attr)
      transactions.each_with_object(Hash.new(0)) do |t, h|
        h[t.description[0, @prefix_length]] += t.public_send(attr)
      end
    end
  end
end
