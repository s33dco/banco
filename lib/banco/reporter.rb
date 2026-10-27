
require_relative 'transaction'
require_relative 'reader'
require_relative 'viewable'
require 'csv'

module Banco
  class Reporter
    include Viewable

    GROUPING_PREFIX_LENGTH = 9

    attr_reader :all_transactions,
                :outgoing_trans,
                :incoming_trans,
                :outgoings,
                :incomings,
                :outgoing_total,
                :incoming_total,
                :name,
                :csv_file_name

    def initialize(csv_file_name, report_name, transactions)
      @csv_file_name = csv_file_name
      @name = report_name
      @all_transactions = transactions
      @outgoing_trans = []
      @incoming_trans = []
      @outgoings = Hash.new(0)
      @incomings = Hash.new(0)
      puts 'formatting data...'
      remove_blank_lines
      split_in_out
      total_outgoing
      total_incoming
      puts "\n\n"
    end

    def remove_blank_lines
      @all_transactions.delete_if { |trans| trans.moneyin.zero? && trans.moneyout.zero? }
    end

    def split_in_out
      @outgoing_trans, @incoming_trans = @all_transactions.partition { |trans| trans.moneyin.zero? && trans.moneyout.positive? }
    end

    def total_outgoing
      @outgoing_trans.each { |trans| @outgoings[trans.description[0, GROUPING_PREFIX_LENGTH]] += trans.moneyout }
      @outgoing_total = @outgoings.values.map.reduce(:+)
    end

    def total_incoming
      @incoming_trans.each { |trans| @incomings[trans.description[0, GROUPING_PREFIX_LENGTH]] += trans.moneyin }
      @incoming_total = @incomings.values.map.reduce(:+)
    end
  end
end

