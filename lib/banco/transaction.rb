
module Banco
  class Transaction
    require 'bigdecimal'
    attr_reader :date, :description, :type, :moneyin, :moneyout, :csv_row_count

    def initialize(date_string, description, type, moneyin, moneyout, csv_row_count)
      @csv_row_count = csv_row_count
      @moneyin = convert(moneyin)
      @moneyout = convert(moneyout)
      @date = date_string
      @description = format('%-22.22s', description.to_s.upcase)
      @type = format('%-8.8s', type.to_s.upcase)
    end

    def convert(money)
      money.nil? ? BigDecimal('0') : BigDecimal(money)
    end

    def to_s
      "#{date} #{type} #{description}"
    end
  end
end

