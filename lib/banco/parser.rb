# frozen_string_literal: true

require 'csv'
require 'banco/transaction'

module Banco
  class Parser
    def initialize(file_path, skip_header: false)
      @file_path = file_path
      @skip_header = skip_header
    end

    def parse
      rows = []
      CSV.foreach(@file_path).with_index do |row, i|
        next if @skip_header && i.zero?

        rows << Transaction.from_row(row)
      end
      rows
    rescue Errno::ENOENT
      raise ArgumentError, "File not found: #{@file_path}"
    end
  end
end
