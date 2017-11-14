module Banco
	class GetFile
		attr_reader :name, :csv_file_name, :summary_name

		def make_name
			@csv_file_name = gets.chomp.downcase
			if @csv_file_name == 'q'
				Viewable::farewell
				exit
			else
				file_checker_cleaner(@csv_file_name)
				@name = @csv_file_name.split('.').first
				@doctype = @csv_file_name.split('.').last
				@summary_name = @name
				@csv_file_name
			end
		end

		def file_checker_cleaner(filename)
			if filename =~/([^\s]+(\.csv)$)/
				puts "\nloading #{filename}..."
			else
				puts "#{filename} won't work !".center(54)
				puts "try again or 'q' to exit".center(54)
				make_name
			end
		end
	end
end

if __FILE__ == $0
	file = Banco::GetFile.new()
	file.make_name
	puts "\n\n\n"
	p file.valid_file
	p file.name
	p file.summary_name
end


