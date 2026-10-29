# frozen_string_literal: true

require_relative 'base'

module Banco
  module Formatter
    class Text < Base
      def self.format_name = 'text'

      def call = bottom_line

      def menu
        output = +''
        output << "Enter :\n\n"
        output << "'a' to view all transactions\n"
        output << "'o' to view all outgoing transactions\n"
        output << "'i' to view all incoming transactions\n"
        output << "'m' for money out summary\n"
        output << "'n' for money in summary\n"
        output << "'b' for the bottom line\n"
        output << "'s' to save summaries to file\n"
        output << "'t' to save transactions to file\n"
        output << "\n'l' to load a new file\n"
        output << "\nor 'q' to quit\n\n\n"
        output
      end

      def transactions_all
        output = +''
        output << dashes << "\n"
        output << "All transactions:\n"
        output << "#{facts(@report.all_transactions)}\n\n"
        @report.all_transactions.each do |trans|
          output << if trans.debit_pence.zero?
                      "#{trans} + #{format_pence(trans.credit_pence)}\n"
                    else
                      "#{trans} - #{format_pence(trans.debit_pence)}\n"
                    end
        end
        output << dashes << "\n\n"
      end

      def transactions_out
        output = +''
        output << dashes << "\n"
        output << "Outgoing Transactions:\n"
        output << "#{facts(@report.outgoing_trans)}\n\n"
        @report.outgoing_trans.each { |t| output << "#{t} - #{format_pence(t.debit_pence)}\n" }
        output << dashes << "\n\n"
      end

      def transactions_in
        output = +''
        output << dashes << "\n"
        output << "Incoming Transactions :\n"
        output << "#{facts(@report.incoming_trans)}\n\n"
        @report.incoming_trans.each { |t| output << "#{t} + #{format_pence(t.credit_pence)}\n" }
        output << dashes << "\n\n"
      end

      def money_out_summary
        print_summary('Outgoings', @report.outgoings, @report.outgoing_total)
      end

      def money_in_summary
        print_summary('Incomings', @report.incomings, @report.incoming_total)
      end

      def bottom_line
        output = +''
        output << dashes << "\n"
        output << facts(@report.all_transactions).to_s.rjust(54) << "\n\n"
        output << "Money In  : #{format_pence(@report.incoming_total)}".rjust(54) << "\n"
        output << "Money Out : #{format_pence(@report.outgoing_total)}".rjust(54) << "\n\n"
        diff = @report.incoming_total - @report.outgoing_total
        output << if @report.outgoing_total > @report.incoming_total
                    "Outgoings exceed Incomings, DEFICIT of #{format_pence(diff.abs)}".rjust(54)
                  else
                    "Incomings exceed Outgoings, SURPLUS of #{format_pence(diff)}".rjust(54)
                  end
        output << "\n" << dashes << "\n\n"
      end

      def save_summary_to_file(path, csv_name: nil)
        File.open(path, 'w') do |f|
          f.puts Time.now.strftime("\n\nprinted : %d %b %y at %I:%M%P")
          f.puts "summarized by Banco from #{csv_name}" if csv_name
          f.puts "\n"
          f.puts money_out_summary
          f.puts "\n"
          f.puts money_in_summary
          f.puts "\n"
          f.puts bottom_line
          f.puts "\n"
          f.puts '♥️ code@s33d.co'.rjust(54)
        end
      end

      def save_transactions_to_file(path, csv_name: nil)
        File.open(path, 'w') do |f|
          f.puts Time.now.strftime("\n\nprinted : %d %b %y at %I:%M%P")
          f.puts "summarized by Banco from #{csv_name}" if csv_name
          f.puts "\n"
          f.puts transactions_out
          f.puts "\n"
          f.puts transactions_in
          f.puts "\n"
          f.puts bottom_line
          f.puts "\n"
          f.puts '♥️ code@s33d.co'.rjust(54)
        end
      end

      def dashes
        '---'.center(55, '-')
      end

      def date_range
        "(#{@report.all_transactions.last&.date} - #{@report.all_transactions.first&.date})"
      end

      def facts(transactions)
        "#{transactions.size} transactions for period #{date_range}"
      end

      private

      def format_pence(pence)
        "£#{format('%10.2f', pence / 100.0)}"
      end

      def print_summary(kind, hash, total)
        output = +''
        output << dashes << "\n"
        output << "#{kind} Summary, totals from #{hash.size} different sources :\n"
        output << "#{date_range}\n"
        hash.sort_by { |_k, v| v }.reverse_each { |k, v| output << "#{k} #{format_pence(v)}\n".rjust(54) }
        output << "\n"
        output << "Total #{kind}: #{format_pence(total)}\n".rjust(54)
        output << dashes << "\n\n"
      end
    end
  end
end
