# frozen_string_literal: true

require 'json'
require_relative 'base'

module Banco
  module Formatter
    class JSONFormatter < Base
      def self.format_name = 'json'

      def call
        {
          date_range: @report.date_range,
          transactions: @report.all_transactions.map { |txn| transaction_hash(txn) },
          outgoing_total_pence: @report.outgoing_total,
          incoming_total_pence: @report.incoming_total,
          surplus_pence: @report.surplus_pence
        }.to_json
      end

      private

      def transaction_hash(txn)
        { date: txn.date, description: txn.description.strip, type: txn.type.strip,
          credit_pence: txn.credit_pence, debit_pence: txn.debit_pence }
      end
    end
  end
end
