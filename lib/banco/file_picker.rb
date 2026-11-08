# frozen_string_literal: true

module Banco
  class FilePicker
    def self.pick(stdin: $stdin, stdout: $stdout)
      files = Dir.glob('*.csv')
      case files.size
      when 0 then prompt_for_path(stdin:, stdout:)
      when 1 then confirm_single(files.first, stdin:, stdout:)
      else        numbered_list(files, stdin:, stdout:)
      end
    end

    class << self
      private

      def prompt_for_path(stdin:, stdout:)
        stdout.print 'No CSV files found. Enter a full path (e.g. ~/Downloads/statement.csv), or q to quit: '
        input = read_input(stdin)
        exit if input.downcase == 'q'
        File.expand_path(input)
      end

      def confirm_single(file, stdin:, stdout:)
        stdout.print "Found #{file} — press Enter to use it, or type a full path (e.g. ~/Downloads/statement.csv): "
        input = read_input(stdin)
        input.empty? ? file : File.expand_path(input)
      end

      def numbered_list(files, stdin:, stdout:)
        stdout.puts "\nCSV files found:"
        files.each_with_index { |f, i| stdout.puts "  #{i + 1}. #{f}" }
        stdout.print "\nEnter a number, a full path (e.g. ~/Downloads/statement.csv), or q to quit: "
        input = read_input(stdin)
        exit if input.downcase == 'q'
        index = input.to_i
        index.between?(1, files.size) ? files[index - 1] : File.expand_path(input)
      end

      def read_input(stdin)
        stdin.gets.chomp
      end
    end
  end
end
