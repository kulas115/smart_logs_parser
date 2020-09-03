# frozen_string_literal: true

RSpec.describe LogsParser::Printer::Unique do
  let(:visits) do
    [
      ['/about', 3],
      ['/about/2', 4],
      ['/contact', 4],
      ['/home', 4],
      ['/index', 4],
      ['/help_page/1', 6]
    ]
  end

  let(:result) do
    <<~TEXT
      /about 3 unique views
      /about/2 4 unique views
      /contact 4 unique views
      /home 4 unique views
      /index 4 unique views
      /help_page/1 6 unique views
    TEXT
  end

  describe '#call' do
    subject(:print) { described_class.call(visits) }

    it 'prints unique visits to the stdout' do
      expect { print }.to output(result).to_stdout
    end
  end
end
