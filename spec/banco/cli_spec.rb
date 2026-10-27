# frozen_string_literal: true

require 'banco/cli'

module Banco
  describe CLI do
    describe '.parse' do
      it 'defaults format to text' do
        expect(described_class.parse([])[:format]).to eq('text')
      end

      it 'defaults prefix_length to 9' do
        expect(described_class.parse([])[:prefix_length]).to eq(9)
      end

      it 'defaults skip_header to false' do
        expect(described_class.parse([])[:skip_header]).to be false
      end

      it 'sets :file from -f' do
        expect(described_class.parse(['-f', 'statements.csv'])[:file]).to eq('statements.csv')
      end

      it 'sets :file from --file' do
        expect(described_class.parse(['--file', 'april.csv'])[:file]).to eq('april.csv')
      end

      it 'sets :prefix_length as Integer from -p' do
        expect(described_class.parse(['-p', '5'])[:prefix_length]).to eq(5)
      end

      it 'sets :skip_header from -H' do
        expect(described_class.parse(['-H'])[:skip_header]).to be true
      end

      it 'sets :format from -F' do
        expect(described_class.parse(['-F', 'json'])[:format]).to eq('json')
      end

      it 'sets :from and :to date strings' do
        options = described_class.parse(['--from', '01/01/17', '--to', '31/01/17'])
        expect(options[:from]).to eq('01/01/17')
        expect(options[:to]).to eq('31/01/17')
      end

      it 'raises OptionParser::InvalidArgument for an unrecognised format' do
        expect { described_class.parse(['-F', 'xml']) }.to raise_error(OptionParser::InvalidArgument)
      end

      it 'exits on -v / --version' do
        expect { described_class.parse(['-v']) }.to raise_error(SystemExit)
      end

      it 'exits on -h / --help' do
        expect { described_class.parse(['-h']) }.to raise_error(SystemExit)
      end
    end
  end
end
