# frozen_string_literal: true

RSpec.describe LogsParser::Reader do
  subject(:reader) { described_class.call(file_path) }

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

  let(:result) do
    ['/help_page/1 126.318.035.038',
     '/contact 184.123.665.067',
     '/home 184.123.665.067',
     '/about/2 444.701.448.104',
     '/help_page/1 929.398.951.889',
     '/index 444.701.448.104']
  end

  context 'when provided file\'s path does not exist' do
    let(:file_path) { 'fake_path' }
    let(:error_msg) do
      "No such file or directory - Provided file under #{file_path} does not exist"
    end

    it 'raises an error' do
      expect { reader }.to raise_error(Errno::ENOENT, error_msg)
    end
  end

  context 'when provided file\'s path exists' do
    let(:log_file) { Tempfile.new(SecureRandom.alphanumeric) }
    let(:file_path) { log_file.path }

    before do
      log_file.write(logs)
      log_file.rewind
    end

    after do
      log_file.close
      log_file.unlink
    end

    it 'reads file by lines and removes leading/trailing whitespace' do
      expect(reader).to eq(result)
    end
  end
end
