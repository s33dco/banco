require 'banco/reader'
module Banco
	describe Reader do 
		before do
			csv_file_name = "test.csv"
			report_name = "test"
			@testreader = Banco::Reader.new(csv_file_name, report_name)
			@testreader.read_in_csv_data
		end
		it "should produce an array for all rows on csv file" do
			expect(@testreader.all_from_csv.length).to eq(10)
		end
	end
end
