# frozen_string_literal: true

require_relative 'transaction'
require_relative 'viewable'
require 'csv'

module Banco
  class Reader
    include Viewable

    attr_reader :all_from_csv, :report_name, :csv_file_name

    def initialize(csv_file_name, report_name, skip_header: false)
      @csv_file_name = csv_file_name
      @report_name = report_name
      @all_from_csv = []
      @skip_header = skip_header
    end

    def read_in_csv_data
      @csv_row_count = 0
      CSV.foreach(csv_file_name) do |row|
        @csv_row_count += 1
        next if @skip_header && @csv_row_count == 1

        @all_from_csv << Transaction.from_row(row)
      end
    rescue ArgumentError => e
      non_numeric_in_csv(e, @csv_row_count)
      puts "sorted ? ('y' to continue or 'q' to exit)".rjust(54)
      input = gets.chomp.downcase
      @all_from_csv = []
      input == 'y' ? retry : Viewable.farewell
    rescue Errno::ENOENT
      puts "Can't find file #{@csv_file_name} - have another go or (q) quit\n\n"
      loop do
        input = gets.chomp.downcase
        case input
        when 'q'
          Viewable.farewell
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

    def non_numeric_in_csv(exception, row_number)
      reason = exception.message.split(':')
      puts "Please check row #{row_number} of #{@csv_file_name},"
      puts "#{reason.last} should be a numeric value".rjust(54)
    end
  end
end
