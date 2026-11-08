# frozen_string_literal: true

require 'csv'
require 'banco/transaction'

module Banco
  class Parser
    def initialize(file_path, skip_header: false, bank_format: BankFormat[:legacy])
      @file_path = file_path
      @skip_header = skip_header
      @bank_format = bank_format
    end

    def parse
      rows = []
      CSV.foreach(@file_path).with_index do |row, i|
        next if @skip_header && i.zero?

        parsed = parse_row(row, i)
        rows << parsed if parsed
      end
      rows
    rescue Errno::ENOENT
      raise ArgumentError, "File not found: #{@file_path}"
    end

    private

    def parse_row(row, index)
      Transaction.from_row(row, @bank_format)
    rescue ArgumentError => e
      if index.zero? && e.message.include?('Non-numeric')
        warn 'Skipping header row (use --header to suppress this warning)'
        return nil
      end
      raise ArgumentError, "Row #{index + 1}: #{e.message}"
    end
  end
end
