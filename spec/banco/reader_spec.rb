# frozen_string_literal: true

require 'banco/reader'
module Banco
  describe Reader do
    before do
      @testreader = Banco::Reader.new('test.csv', 'test')
      @testreader.read_in_csv_data
    end

    it 'should produce an array for all rows on csv file' do
      expect(@testreader.all_from_csv.length).to eq(10)
    end

    it 'skips the first row when skip_header: true' do
      reader = Banco::Reader.new('test.csv', 'test', skip_header: true)
      reader.read_in_csv_data
      expect(reader.all_from_csv.length).to eq(9)
    end
  end
end
