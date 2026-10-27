# frozen_string_literal: true

module Banco
  Transaction = Data.define(:date, :description, :type, :credit_pence, :debit_pence) do
    class << self
      def from_row(row)
        new(
          date: row[0],
          description: row[1].to_s.upcase.ljust(22)[0, 22],
          type: row[2].to_s.upcase.ljust(8)[0, 8],
          credit_pence: parse_pence(row[3]),
          debit_pence: parse_pence(row[4])
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
    end

    def to_s = "#{date} #{type} #{description}"
  end
end
