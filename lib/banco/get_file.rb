
module Banco
  class GetFile
    attr_reader :name, :csv_file_name, :summary_name

    def initialize
      @csv_file_name = gets.chomp.downcase
      if @csv_file_name == 'q'
        Viewable::farewell
        exit
      else
        file_checker_cleaner(@csv_file_name)
        @name = @csv_file_name.split('.').first
        make_name
      end
    end

    def make_name
      @name = @csv_file_name.split('.').first
      @doctype = @csv_file_name.split('.').last
      @summary_name = @name
      @csv_file_name
    end

    def file_checker_cleaner(filename)
      if filename =~ /([^\s]+(\.csv)$)/
        puts "\nloading #{filename}..."
      else
        puts "#{filename} isn't a valid file for Banco !".center(54)
        throw
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  file = Banco::GetFile.new
  file.make_name
  puts "\n\n\n"
  p file.valid_file
  p file.name
  p file.summary_name
end
