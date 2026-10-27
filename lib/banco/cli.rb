# frozen_string_literal: true

require 'optparse'
require 'banco/version'

module Banco
  class CLI
    VALID_FORMATS = %w[text json csv].freeze

    def self.parse(argv = ARGV)
      options = { format: 'text', prefix_length: 9, skip_header: false }
      parser = build_parser(options)
      parser.parse!(argv)
      options
    end

    class << self
      private

      def build_parser(options)
        OptionParser.new do |opts|
          opts.banner = 'Usage: banco [options]'
          opts.on('-f', '--file FILE', 'CSV file to analyse') { |v| options[:file] = v }
          opts.on('-p', '--prefix-length N', Integer, 'Grouping prefix length (default 9)') do |v|
            options[:prefix_length] = v
          end
          opts.on('-H', '--header', 'Skip first row as header') { options[:skip_header] = true }
          opts.on('--from DATE', 'Filter from date (dd/mm/yy)') { |v| options[:from] = v }
          opts.on('--to DATE', 'Filter to date (dd/mm/yy)') { |v| options[:to] = v }
          opts.on('-F', '--format FORMAT', VALID_FORMATS, "Output format (#{VALID_FORMATS.join('/')})") do |v|
            options[:format] = v
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
