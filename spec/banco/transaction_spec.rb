require 'banco/transaction'

module Banco
	describe Transaction do
		before do
			@trans1 = Transaction.new("12/01/17","some transaction", "credit", "57.91", "0.00", "1")
			@trans2 = Transaction.new("13/01/17","some other transaction", "debit", "0.00", "57.91",'2')
		end

		# it "Should convert money in values to pence" do
		#  	expect(@trans1.moneyin).to eq(5791)
		# end

		# it "Should convert money out values to pence" do
		# 	expect(@trans2.moneyout).to eq(5791)
		# end

		it "Should have a description string of 22 characters (upcase)" do
			expect(@trans2.description).to eq("SOME OTHER TRANSACTION")
			expect(@trans1.description).to eq("SOME TRANSACTION      ")
		end

		it "Should have a type string upcased and 8 characters long" do
			expect(@trans2.type).to eq("DEBIT   ")
		end

		it "Should have a date string" do
			expect(@trans1.date).to eq("12/01/17")
		end

		it "Should have a row number" do
			expect(@trans2.csv_row_count).to eq("2")
		end

		it "should have a to_s of all date description type" do
			expect(@trans1.to_s).to eq("12/01/17 CREDIT   SOME TRANSACTION      ")
		end

		it "convert empty strings in money columns to integers" do
			expect(@trans1.moneyout).to eq(0)
		end

		it "convert empty strings in money columns to integers" do
			expect(@trans2.moneyin).to eq(0)
		end
	end
end
