# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Printer::Total do
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
      /about 3 visits
      /about/2 4 visits
      /contact 4 visits
      /home 4 visits
      /index 4 visits
      /help_page/1 6 visits
    TEXT
  end

  describe '#call' do
    subject(:print) { described_class.call(visits) }

    it 'print total visits to the stdout' do
      expect { print }.to output(result).to_stdout
    end
  end
end
