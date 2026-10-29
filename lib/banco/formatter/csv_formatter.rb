# frozen_string_literal: true

require 'csv'
require_relative 'base'

module Banco
  module Formatter
    class CsvFormatter < Base
      def self.format_name = 'csv'

      def call
        CSV.generate do |csv|
          csv << %w[date description type credit_pence debit_pence]
          @report.all_transactions.each do |t|
            csv << [t.date, t.description.strip, t.type.strip, t.credit_pence, t.debit_pence]
          end
        end
      end
    end
  end
end
