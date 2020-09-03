# frozen_string_literal: true

RSpec.describe Parser do
  let(:sample_log_path) { './sample_webserver.log' }

  describe '#call' do
    subject(:parse) { described_class.new(file_path: sample_log_path, schema: schema).call }

    context 'when using :total schema' do
      let(:schema) { :total }

      let(:results) do
        <<~TEXT
          /help_page/1 6 visits
          /contact 4 visits
          /home 4 visits
          /about/2 4 visits
          /index 4 visits
          /about 3 visits
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
          /help_page/1 5 unique views
          /home 4 unique views
          /index 4 unique views
          /contact 3 unique views
          /about/2 3 unique views
          /about 3 unique views
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
          /home 4 visits
          /about/2 4 visits
          /index 4 visits
          /about 3 visits
        TEXT
      end

      it 'it prints total visits to the srdout' do
        expect { parse }.to output(results).to_stdout
      end
    end
  end
end
