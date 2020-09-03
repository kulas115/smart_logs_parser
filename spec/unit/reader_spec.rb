# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Reader do
  subject(:reader) { described_class.new(log_file.path) }

  let(:logs) do
    <<~LOGS
      /help_page/1 126.318.035.038
      /contact 184.123.665.067
      /home 184.123.665.067
      /about/2 444.701.448.104
      /help_page/1 929.398.951.889
      /index 444.701.448.104
    LOGS
  end

  let(:log_file) { Tempfile.new(SecureRandom.alphanumeric) }

  let(:result) do
    ['/help_page/1 126.318.035.038',
     '/contact 184.123.665.067',
     '/home 184.123.665.067',
     '/about/2 444.701.448.104',
     '/help_page/1 929.398.951.889',
     '/index 444.701.448.104']
  end

  before do
    log_file.write(logs)
    log_file.rewind
  end

  after { log_file.close }

  it 'reads file by lines and removes leading/trailing whitespace' do
    expect(reader.call).to eq(result)
  end
end
