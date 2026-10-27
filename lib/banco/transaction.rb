# frozen_string_literal: true

require 'date'
require 'banco/bank_format'

module Banco
  Transaction = Data.define(:date, :description, :type, :credit_pence, :debit_pence, :parsed_date) do
    class << self
      def from_row(row, fmt = BankFormat[:legacy])
        date_str = row[fmt.date_col]
        new(
          date: date_str,
          description: row[fmt.description_col].to_s.upcase.ljust(22)[0, 22],
          type: (fmt.type_col && row[fmt.type_col]).to_s.upcase.ljust(8)[0, 8],
          credit_pence: parse_pence(row[fmt.credit_col]),
          debit_pence: parse_pence(row[fmt.debit_col]),
          parsed_date: parse_date(date_str, fmt.date_fmt)
        )
      end

      private

      def parse_pence(str)
        return 0 if str.nil? || str.strip.empty?

        Float(str) # validates; exact conversion uses Rational below
        (str.to_r * 100).to_i
      rescue ArgumentError
        raise ArgumentError, "Non-numeric money value: #{str.inspect}"
      end

      def parse_date(str, fmt_str)
        return nil if str.nil? || str.strip.empty? || fmt_str.nil?

        Date.strptime(str, fmt_str)
      rescue Date::Error
        nil
      end
    end

    def to_s = "#{date} #{type} #{description}"
  end
end
