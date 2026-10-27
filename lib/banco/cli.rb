# frozen_string_literal: true

require 'optparse'
require 'date'
require 'banco/version'
require 'banco/bank_format'
require 'banco/formatter/base'
require 'banco/formatter/text'
require 'banco/formatter/json_formatter'
require 'banco/formatter/csv_formatter'

module Banco
  class CLI
    def self.parse(argv = ARGV)
      options = { format: 'text', prefix_length: 9, skip_header: false, bank: :legacy }
      parser = build_parser(options)
      parser.parse!(argv)
      options
    end

    # Parse a --from/--to value strictly against the bank's date format.
    # Rejects values that don't fully match (e.g. a 4-digit year against a
    # 2-digit-year format) or that are out of range, exiting with a message
    # rather than silently misparsing or crashing with a backtrace.
    def self.filter_date(value, fmt)
      return nil unless value

      parts = Date._strptime(value, fmt)
      raise Date::Error if parts.nil? || parts[:leftover]

      Date.strptime(value, fmt)
    rescue Date::Error
      warn "Invalid date #{value.inspect} — expected a date matching #{fmt}"
      exit 1
    end

    def self.hello
      puts "\n\n"
      puts 'Banco will summarize your bank statements.'.center(55)
      puts 'import a .csv file for review'.center(55)
      puts "\n\n"
      puts 'the .csv file should have :'.center(55)
      puts 'NO headers'.center(55)
      puts 'with columns ordered (left to right)'.center(55)
      puts 'date - description - type - money in - money out'.center(55)
      puts 'all additional columns will be ignored'.center(55)
    end

    def self.farewell
      puts "\n\n"
      puts '*'.center(55, '*')
      puts '  Banco  '.center(55, '*')
      puts '  hope your numbers were positive  '.center(55, '*')
      puts '  ♥️  code@s33d.co   '.center(56, '*')
      puts '*'.center(55, '*')
      puts "\n\n\n"
      exit
    end

    class << self
      private

      def build_parser(options)
        fmt_names  = Formatter::Base.names
        bank_names = BankFormat.names.map(&:to_s)
        OptionParser.new do |opts|
          opts.banner = 'Usage: banco [options]'
          opts.on('-f', '--file FILE', 'CSV file to analyse') { |v| options[:file] = v }
          opts.on('-p', '--prefix-length N', Integer, 'Grouping prefix length (default 9)') do |v|
            options[:prefix_length] = v
          end
          opts.on('-H', '--header', 'Skip first row as header') { options[:skip_header] = true }
          opts.on('--from DATE', 'Filter from date (format matches --bank)') { |v| options[:from] = v }
          opts.on('--to DATE', 'Filter to date (format matches --bank)') { |v| options[:to] = v }
          opts.on('-F', '--format FORMAT', fmt_names, "Output format (#{fmt_names.join('/')})") do |v|
            options[:format] = v
          end
          opts.on('-b', '--bank NAME', bank_names, "Bank CSV format (#{bank_names.join('/')})") do |v|
            options[:bank] = v.to_sym
          end
          opts.on('-v', '--version', 'Print version and exit') do
            puts Banco::VERSION
            exit
          end
          opts.on('-h', '--help', 'Show this help') do
            puts opts
            exit
          end
        end
      end
    end
  end
end
