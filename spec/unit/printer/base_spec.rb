# frozen_string_literal: true

RSpec.describe LogsParser::Printer::Base do
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

  describe '#call' do
    subject(:print) { described_class.call(visits) }

    it 'raises NotImplementedError' do
      expect { print }.to raise_error(NotImplementedError)
    end
  end
end
