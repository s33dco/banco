require_relative 'transaction'
require_relative 'reader'
require_relative 'viewable'
require 'csv'

module Banco
  class Reporter

    include Viewable

		attr_reader :all_transactions, :outgoing_trans, :incoming_trans,
									:outgoings, :incomings, :outgoing_total, :incoming_total,
									:name, :csv_file_name

		def initialize(csv_file_name, report_name, transactions)
			@csv_file_name = csv_file_name
					@name = report_name
			@all_transactions = transactions
					@outgoing_trans = []
					@incoming_trans = []
					@outgoings = Hash.new(0)
					@incomings = Hash.new(0)
					puts "formating data..."
					remove_blank_lines
					split_in_out
					total_outgoing
					total_incoming
					puts "\n\n"
		end


		def remove_blank_lines
					@all_transactions.delete_if{|trans| trans.moneyin == 0 && trans.moneyout == 0}
		end

		def split_in_out
				@outgoing_trans, @incoming_trans = @all_transactions.partition{|trans| trans.moneyin == 0 && trans.moneyout > 0}
		end

		def total_outgoing
				@outgoing_trans.each{|trans| @outgoings[trans.description[0..8]] += trans.moneyout}
				@outgoing_total = @outgoings.values.map.reduce(:+)
		end

		def total_incoming
				@incoming_trans.each{|trans| @incomings[trans.description[0..8]] += trans.moneyin}
				@incoming_total = @incomings.values.map.reduce(:+)
		end
	end
end


if __FILE__ == $0
    reader = Banco::Reader.new("test.csv", "test")
    reader.read_in_csv_data
    puts "\n\n\n#all csv data from reader object\n\n"
    puts "#{reader.all_from_csv}\n\n"
    report = Banco::Reporter.new(reader.csv_file_name, reader.report_name, reader.all_from_csv)
    puts "#{report.name} is the Reporter object's name\nReporter object contents below, (3 arrays, 2 hashes):\n\n"
    puts "\n\nall transactions array\n"
    p report.all_transactions
    puts "\n\noutgoings array\n"
    p report.outgoing_trans
    puts "\n\nincomings array\n"
    p report.incoming_trans
    puts "\n\nOutgoings hash\n"
    p report.outgoings
    puts "\n\nIncomings hash\n"
    p report.incomings
end
