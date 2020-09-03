# frozen_string_literal: true

RSpec.describe LogsParser::Worker do
  let(:worker) do
    described_class.new(
      input_path: input_path,
      reader: reader,
      storer: storer,
      line_splitter: line_splitter,
      counter: counter,
      sorter: sorter,
      printer: printer
    )
  end

  let(:input_path)    { 'fake_path' }
  let(:reader)        { LogsParser::Reader }
  let(:storer)        { LogsParser::Storer }
  let(:storer_double) { instance_double('LogsParser::Storer', call: true) }
  let(:line_splitter) { LogsParser::LineSplitter }
  let(:counter)       { LogsParser::Counter::Total }
  let(:sorter)        { LogsParser::Sorter }
  let(:printer)       { LogsParser::Printer::Total }
  let(:lines)         { instance_double(Array) }
  let(:visits)        { instance_double(Hash) }

  before do
    allow(storer).to receive(:new).and_return(storer_double)
  end

  shared_examples 'correctly calls all services' do
    it 'correctly calls all services in order' do
      expect(reader).to receive(:call).with(input_path).once.and_return(lines).ordered
      expect(line_splitter).to receive(:new)
      expect(storer).to receive(:new)
      expect(storer_double).to receive(:call).with(lines).once.and_return(visits).ordered
      expect(counter).to receive(:call).with(visits).once.and_return(visits).ordered
      expect(sorter).to receive(:call).with(visits).once.and_return(visits).ordered
      expect(printer).to receive(:call).with(visits).once

      subject
    end
  end

  describe '#call' do
    subject { worker.call }

    context 'with correct input path and default services' do
      include_examples 'correctly calls all services'
    end

    context 'with alternative services' do
      let(:counter) { LogsParser::Counter::Unique }
      let(:printer) { LogsParser::Printer::Unique }

      include_examples 'correctly calls all services'
    end
  end
end
