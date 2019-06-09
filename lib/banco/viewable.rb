module Banco
  module Viewable
    def menu
      puts "Enter :\n"
      puts "'a' to view all transactions"
      puts "'o' to view all outgoing transactions"
      puts "'i' to view all incoming transactions"
      puts "'m' for money out summary"
      puts "'n' for money in summary"
      puts "'b' for the bottom line"
      puts "'s' to save summaries to file"
      puts "'t' to save transactions to file"
      puts "\n'l' to load a new file\n"
      puts "\nor 'q' to quit\n\n\n"
    end

    def to_pounds(money)
      format = sprintf("%10.2f", money.truncate(2))
      "£#{format}"
    end

    def dashes
      "---".center(55,"-")
    end

    def date_range
      "(#{self.all_transactions.last.date} - #{self.all_transactions.first.date})"
    end

    def facts(transactions)
      "#{transactions.size} transactions for period #{date_range}"
    end

    def money_out_summary
      print_summary("Outgoings", self.outgoings, self.outgoing_total)
    end

    def money_in_summary
      print_summary("Incomings", self.incomings, self.incoming_total)
    end

    def transactions_all
      output = output_s = ""
      output << dashes
      output << "\n"
      output << "All transactions:\n"
      output << "#{facts(self.all_transactions)}\n\n"
      self.all_transactions.each do |trans|
        if trans.moneyout == 0
          output << "#{trans} + #{to_pounds(trans.moneyin)}\n"
        else
          output << "#{trans} - #{to_pounds(trans.moneyout)}\n"
        end
      end
      output << dashes
      output << "\n\n"
    end

    def transactions_out
      output = output_s = ""
      output << dashes
      output << "\n"
      output << "Outgoing Transactions:\n"
      output << "#{facts(self.outgoing_trans)}\n\n"
      self.outgoing_trans.each{|trans| output << "#{trans} - #{to_pounds(trans.moneyout)}\n"}
      output << dashes
      output << "\n\n"
    end

    def transactions_in
      output = output_s = ""
      output << dashes
      output << "\n"
      output << "Incoming Transactions :\n"
      output << "#{facts(self.incoming_trans)}\n\n"
      self.incoming_trans.each{|trans| output << "#{trans} + #{to_pounds(trans.moneyin)}\n"}
      output << dashes
      output << "\n\n"
    end

    def print_summary(kind, hash, total)
      output = output_s = ""
      output << dashes
      output << "\n"
      output << "#{kind} Summary, totals from #{hash.size} different sources :\n"
      output << "#{date_range}\n"
      hash.sort_by{|_k,v| v}.reverse.each{|k,v| output << "#{k} #{to_pounds(v)}\n".rjust(54)}
      output << "\n"
      output << "Total #{kind}: #{to_pounds(total)}\n".rjust(54)
      output << dashes
      output << "\n\n"
    end

    def bottom_line
      output = output_s = ""
      output << dashes
      output << "\n"
      output << "#{facts(self.all_transactions)}".rjust(54)
      output << "\n\n"
      output << "Money In  : #{to_pounds(self.incoming_total)}".rjust(54)
      output << "\n"
      output << "Money Out : #{to_pounds(self.outgoing_total)}".rjust(54)
      output << "\n\n"
      diff = self.incoming_total - self.outgoing_total
        if self.outgoing_total > self.incoming_total
          output << "Outgoings exceed Incomings, DEFICIT of #{to_pounds(diff)}".rjust(54)
        else
          output << "Incomings exceed Outgoings, SURPLUS of #{to_pounds(diff)}".rjust(54)
        end
      output << "\n"
      output << dashes
      output << "\n\n"
    end

    def self.farewell
      puts "\n\n"
      puts "*".center(55,'*')
      puts "  Banco  ".center(55,'*')
      puts "  hope your numbers were positive  ".center(55,'*')
      puts "   code@s33d.co   ".center(55,'*')
      puts "*".center(55,'*')
      puts "\n\n\n"
      exit
    end

    def self.hello
      puts "\n\n"
      puts "Banco will summarize your bank statements.".center(55)
      puts "import a .csv file for review".center(55)
      puts "\n\n"
      puts "the .csv file should have :".center(55)
      puts "NO headers".center(55)
      puts "with columns ordered (left to right)".center(55)
      puts "date - description - type - money in - money out".center(55)
      puts "all additional columns will be ignored".center(55)
    end

    def self.prompt
      puts "\n\n"
      puts "Enter the name of you .csv file to review".center(54)
      puts "(use 'test.csv' for the test file)".center(54)
      puts "or 'q' to quit...".center(55)
      puts "\n\n"
    end

    def save_summary_to_file(to_file="#{self.name}_summary.txt")
      File.open(to_file, "w") do |file|
        t = Time.now
        file.puts t.strftime("\n\nprinted : %d %b %y at %I:%M%P")
        file.puts "summarized by Banco from #{self.csv_file_name}"
        file.puts "\n"
        file.puts self.money_out_summary
        file.puts "\n"
        file.puts self.money_in_summary
        file.puts "\n"
        file.puts self.bottom_line
        file.puts "\n"
        file.puts "code@s33d.co".rjust(54)
      end
      puts "\n\nfile saved as #{self.name}_summary.txt\n\n"
    end

    def save_transactions_to_file(to_file="#{self.name}_transactions.txt")
        File.open(to_file, "w") do |file|
          t = Time.now
          file.puts t.strftime("\n\nprinted : %d %b %y at %I:%M%P")
          file.puts "summarized by Banco from #{self.csv_file_name}"
          file.puts "\n"
          file.puts self.transactions_out
          file.puts "\n"
          file.puts self.transactions_in
          file.puts "\n"
          file.puts self.bottom_line
          file.puts "\n"
          file.puts "code@s33d.co".rjust(54)
        end
        puts "\n\nfile saved as #{self.name}_transactions.txt\n\n"
    end
  end
end
