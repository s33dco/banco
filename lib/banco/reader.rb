require_relative 'transaction'
require_relative 'viewable'
require 'csv'

module Banco
	class Reader
		include Viewable

		attr_reader :all_from_csv, :report_name, :csv_file_name

		def initialize(csv_file_name, report_name)
			@csv_file_name = csv_file_name
			@report_name = report_name
			@all_from_csv = []
		end

		def read_in_csv_data
			begin
				@csv_row_count = 1

				CSV.foreach(csv_file_name) do |row|
					all_from_csv << Transaction.new(row[0],row[1],row[2],row[3],row[4],@csv_row_count)
					@csv_row_count += 1
				end

			rescue ArgumentError => e
				non_numeric_in_csv(e, @csv_row_count)
				puts "sorted ? ('y' to continue or 'q' to exit)".rjust(54)
				input = gets.chomp.downcase
				@all_from_csv = []
				input == "y" ? retry : Viewable::farewell

			rescue Errno::ENOENT => e
				puts "Can't find file #{@csv_file_name} - have another go or (q) quit\n\n"
				loop do
					input = gets.chomp.downcase
					case input
						when 'q'
							Viewable::farewell
							exit
						when /([^\s]+(\.csv)$)/
							@csv_file_name = input
							break
						else
		    			puts "\ninvalid file - try again or 'q' to quit\n\n"
	    			end
    		end
  		retry
		end
	end

		def non_numeric_in_csv(exception, row_number)
            reason = exception.message.split(':')
            puts "Please check row #{row_number} of #{@csv_file_name},"
            puts "#{reason.last} should be a numeric value".rjust(54)
        end
	end
end

if __FILE__ == $0
    reader = Banco::Reader.new("test.csv", "test")
    reader.read_in_csv_data
    puts reader.report_name
    puts reader.csv_file_name
    puts reader.all_from_csv
    p reader
end
