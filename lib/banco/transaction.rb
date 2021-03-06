
module Banco
  class Transaction
    require 'bigdecimal'
    attr_reader :date, :description, :type, :moneyin, :moneyout, :csv_row_count

    def initialize(date_string, description, type, moneyin, moneyout, csv_row_count)
      @csv_row_count = csv_row_count
      @moneyin = convert(moneyin)
      @moneyout = convert(moneyout)
      @date = date_string
      @description = format('%-22.22s', description.upcase.to_s)
      @type = format('%-8.8s', type.upcase.to_s)
    end

    def convert(money)
      money.nil? ? BigDecimal('0') : BigDecimal(money)
    end

    def to_s
      "#{date} #{type} #{description}"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  trans = Banco::Transaction.new('01/01/17', 'Supermarket', 'Purchase', '72.90', '0', '1')
  p trans
  t = Banco::Transaction.new
  t.send(:initialize, '02/02/18', 'new way', 'credit', '0', '111.11', '2')
  p t
end
