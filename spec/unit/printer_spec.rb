# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Printer do
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

  context 'when calling with :uniq as argument' do
    subject(:print) { described_class.new.call(visits, :uniq) }

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

    it 'print unique visits to the stdout' do
      expect { print }.to output(result).to_stdout
    end
  end

  context 'when calling without count argument' do
    subject(:print) { described_class.new.call(visits) }

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

    it 'print unique visits to the stdout' do
      expect { print }.to output(result).to_stdout
    end
  end
end
