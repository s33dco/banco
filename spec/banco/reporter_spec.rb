require 'banco/reporter'
require 'banco/reader'
module Banco
	describe Reporter do 
		before do
			csv_file_name = "test.csv"
			report_name = "test"
			@testreader = Banco::Reader.new(csv_file_name, report_name)
			@testreader.read_in_csv_data
			@tester = Banco::Reporter.new('test.csv', 'test', @testreader.all_from_csv)
			@tester.remove_blank_lines
            @tester.split_in_out
            @tester.total_outgoing
            @tester.total_incoming
		end

		it "should remove transactions with zero values (moneyin / moneyout)" do
			expect(@tester.all_transactions.size).to eq(8)
		end
		

		it "should produce an array of incoming transactions" do
		    expect(@tester.incoming_trans.size).to eq(4)
		end

		it "should produce an array of outgoing transactions" do
			expect(@tester.outgoing_trans.size).to eq(4)
		end

		it "should produce a hash of outgoing transactions" do
			expect(@tester.outgoings.size).to eq(2)
		end

		it "should produce a hash of incoming transactions" do
			expect(@tester.incomings.size).to eq(2)
		end

		it "should sum incoming transactions by matching description string" do
			expect(@tester.incomings['INCOMING2']).to eq(183.34)
		end

		it "should sum outgoing transactions by matching description string" do
			expect(@tester.outgoings['OUTGOING2']).to eq(182.68)
		end

		it "should sum total incoming transactions" do
			expect(@tester.incoming_total).to eq(321.58)
		end

		it "should sum total outgoing transactions" do
			expect(@tester.outgoing_total).to eq(320.92)
		end
	end
end