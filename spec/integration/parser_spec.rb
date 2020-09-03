# frozen_string_literal: true

RSpec.describe Parser do
  let(:log_file)        { Tempfile.new(SecureRandom.alphanumeric) }
  let(:sample_log_path) { log_file.path }
  let(:logs) do
    <<~LOGS
      /help_page/1 126.318.035.038
      /help_page/1 126.318.035.038
      /help_page/1 184.123.665.067
      /help_page/1 126.318.035.038
      /help_page/1 444.701.448.104
      /help_page/1 929.398.951.889
      /contact 184.123.665.067
      /contact 126.318.035.038
      /contact 444.701.448.104
      /contact 184.123.665.067
      /home 184.123.665.067
      /home 444.701.448.104
      /home 184.123.665.067
      /about/2 444.701.448.104
      /about/2 444.701.448.104
      /index 444.701.448.104
    LOGS
  end

  before do
    log_file.write(logs)
    log_file.rewind
  end

  after { log_file.close }

  describe '#call' do
    subject(:parse) { described_class.new(file_path: sample_log_path, schema: schema).call }

    context 'when using :total schema' do
      let(:schema) { :total }

      let(:results) do
        <<~TEXT
          /help_page/1 6 visits
          /contact 4 visits
          /home 3 visits
          /about/2 2 visits
          /index 1 visits
        TEXT
      end

      it 'it prints total visits to the srdout' do
        expect { parse }.to output(results).to_stdout
      end
    end

    context 'when using :unique schema' do
      let(:schema) { :unique }

      let(:results) do
        <<~TEXT
          /help_page/1 4 unique views
          /contact 3 unique views
          /home 2 unique views
          /about/2 1 unique views
          /index 1 unique views
        TEXT
      end

      it 'it prints unique visits to the srdout' do
        expect { parse }.to output(results).to_stdout
      end
    end

    context 'when schema is not specified' do
      let(:schema) { :nil }

      let(:results) do
        <<~TEXT
          /help_page/1 6 visits
          /contact 4 visits
          /home 3 visits
          /about/2 2 visits
          /index 1 visits
        TEXT
      end

      it 'it prints total visits to the srdout' do
        expect { parse }.to output(results).to_stdout
      end
    end
  end
end
