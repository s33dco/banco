# frozen_string_literal: true

require_relative 'viewable'
require_relative 'grouper'

module Banco
  class Reporter
    include Viewable

    GROUPING_PREFIX_LENGTH = Grouper::DEFAULT_PREFIX_LENGTH

    attr_reader :all_transactions, :outgoing_trans, :incoming_trans,
                :outgoings, :incomings, :outgoing_total, :incoming_total,
                :name, :csv_file_name

    def initialize(csv_file_name, report_name, transactions)
      @csv_file_name = csv_file_name
      @name = report_name
      puts 'formatting data...'
      report = Grouper.new(transactions).call
      @all_transactions = report.all_transactions
      @outgoing_trans   = report.outgoing_trans
      @incoming_trans   = report.incoming_trans
      @outgoings        = report.outgoings
      @incomings        = report.incomings
      @outgoing_total   = report.outgoing_total
      @incoming_total   = report.incoming_total
      puts "\n\n"
    end
  end
end
