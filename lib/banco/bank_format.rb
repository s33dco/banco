# frozen_string_literal: true

module Banco
  class BankFormat
    attr_reader :date_col, :description_col, :type_col, :credit_col, :debit_col, :date_fmt

    def self.define(name, &)
      fmt = new
      fmt.instance_eval(&)
      formats[name.to_sym] = fmt
    end

    def self.[](name)
      formats.fetch(name.to_sym) { raise ArgumentError, "Unknown bank format: #{name}" }
    end

    def self.names
      formats.keys
    end

    def self.formats
      @formats ||= {}
    end

    # DSL methods — called inside instance_eval blocks
    def date_column(col)        = @date_col = col
    def description_column(col) = @description_col = col
    def type_column(col)        = @type_col = col
    def credit_column(col)      = @credit_col = col
    def debit_column(col)       = @debit_col = col
    def date_format(fmt)        = @date_fmt = fmt
  end

  BankFormat.define(:legacy) do
    date_column        0
    description_column 1
    type_column        2
    credit_column      3
    debit_column       4
    date_format        '%d/%m/%y'
  end

  BankFormat.define(:split_columns) do
    date_column        0
    description_column 1
    type_column        2
    credit_column      3
    debit_column       4
    date_format        '%d/%m/%Y'
  end

  BankFormat.define(:signed_amount) do
    date_column        0
    description_column 1
    credit_column      2
    debit_column       2
    date_format        '%Y-%m-%d'
  end
end
