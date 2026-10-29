# frozen_string_literal: true

require 'banco/version'
require 'banco/bank_format'
require 'banco/transaction'
require 'banco/report'
require 'banco/grouper'
require 'banco/parser'
require 'banco/formatter/base'
require 'banco/formatter/text'
require 'banco/formatter/json_formatter'
require 'banco/formatter/csv_formatter'
require 'banco/cli'
require 'banco/file_picker'

user_formats = File.expand_path('~/.banco/formats.rb')
load user_formats if File.exist?(user_formats)
