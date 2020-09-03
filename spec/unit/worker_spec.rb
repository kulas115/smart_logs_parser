# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/MultipleExpectations, RSpec/ExampleLength
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
  let(:storer_double) { instance_double('LogsParser::Storer', call: visits) }
  let(:line_splitter) { LogsParser::LineSplitter }
  let(:counter)       { LogsParser::Counter::Total }
  let(:sorter)        { LogsParser::Sorter }
  let(:printer)       { LogsParser::Printer::Total }
  let(:lines)         { instance_double(Array) }
  let(:visits)        { instance_double(Hash) }

  before do
    allow(reader).to receive(:call).and_return(lines)
    allow(line_splitter).to receive(:new)
    allow(storer).to receive(:new).and_return(storer_double)
    allow(counter).to receive(:call).and_return(visits)
    allow(sorter).to receive(:call).and_return(visits)
    allow(printer).to receive(:call)
  end

  shared_examples 'correctly calls all services' do
    it 'correctly calls all services in order' do
      subject

      expect(reader).to have_received(:call).with(input_path).once
      expect(line_splitter).to have_received(:new)
      expect(storer).to have_received(:new)
      expect(storer_double).to have_received(:call).with(lines).once
      expect(counter).to have_received(:call).with(visits).once
      expect(sorter).to have_received(:call).with(visits).once
      expect(printer).to have_received(:call).with(visits).once
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
# rubocop:enable all
