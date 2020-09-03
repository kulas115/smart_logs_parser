# frozen_string_literal: true

require 'spec_helper'
RSpec.describe LogsParser do
  let(:sample_log_path) { './sample_webserver.log' }

  describe '#call' do
    context 'when passing Total classes' do
      subject(:parse) do
        LogsParser::Worker.new(input_path: sample_log_path,
                               counter: LogsParser::Counter::Total.new,
                               printer: LogsParser::Printer::Total.new).call
      end

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

    context 'when passing Unique classes' do
      subject(:parse) do
        LogsParser::Worker.new(input_path: sample_log_path,
                               counter: LogsParser::Counter::Unique.new,
                               printer: LogsParser::Printer::Unique.new).call
      end

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

      it 'it prints total visits to the srdout' do
        expect { parse }.to output(results).to_stdout
      end
    end
  end
end
