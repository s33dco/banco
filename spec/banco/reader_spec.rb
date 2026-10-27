# frozen_string_literal: true

require 'banco/reader'

module Banco
  describe Reader do
    let(:test_csv) { File.expand_path('../../fixtures/test.csv', __FILE__) }

    before do
      @testreader = Banco::Reader.new(test_csv, 'test')
      @testreader.read_in_csv_data
    end

    it 'should produce an array for all rows on csv file' do
      expect(@testreader.all_from_csv.length).to eq(10)
    end

    it 'skips the first row when skip_header: true' do
      reader = Banco::Reader.new(test_csv, 'test', skip_header: true)
      reader.read_in_csv_data
      expect(reader.all_from_csv.length).to eq(9)
    end

    describe 'non-numeric money value recovery' do
      let(:bad_csv) { File.expand_path('../../fixtures/bad_money.csv', __FILE__) }

      it 'resets transactions and calls farewell when user quits after bad row' do
        reader = Reader.new(bad_csv, 'bad money test')
        allow(reader).to receive(:gets).and_return("q\n")
        allow(Viewable).to receive(:farewell)
        reader.read_in_csv_data
        expect(reader.all_from_csv).to be_empty
      end
    end
  end
end
