# frozen_string_literal: true

require 'csv'
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
        output << "'s' to save summary as csv\n"
        output << "'t' to save transactions as csv\n"
        output << "\n'l' to load a new file\n"
        output << "'+' to merge another file into the current set\n"
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

      def save_summary_to_file(path)
        CSV.open(path, 'w') do |csv|
          csv << %w[Direction Category Total]
          @report.outgoings.sort_by { |_, v| -v }.each do |k, v|
            csv << ['Outgoing', k.strip, format('%.2f', v / 100.0)]
          end
          @report.incomings.sort_by { |_, v| -v }.each do |k, v|
            csv << ['Incoming', k.strip, format('%.2f', v / 100.0)]
          end
        end
      end

      def save_transactions_to_file(path)
        CSV.open(path, 'w') do |csv|
          csv << %w[Date Description Amount]
          @report.all_transactions.each do |t|
            amount = t.credit_pence.positive? ? t.credit_pence / 100.0 : -(t.debit_pence / 100.0)
            csv << [t.date, t.description.strip, format('%.2f', amount)]
          end
        end
      end

      def dashes
        '---'.center(55, '-')
      end

      def date_range
        first = @report.all_transactions.first
        last_t = @report.all_transactions.last
        days = (first.parsed_date - last_t.parsed_date).to_i.abs + 1 if first&.parsed_date && last_t&.parsed_date
        day_str = days ? " — #{days} #{days == 1 ? 'day' : 'days'}" : ''
        "(#{last_t&.date} - #{first&.date})#{day_str}"
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
