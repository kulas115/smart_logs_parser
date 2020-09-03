# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Storer do
  subject(:store) { described_class.new.call(lines) }

  let(:lines) do
    [
      '/help_page/1 126.318.035.038',
      '/help_page/1 929.398.951.889',
      '/contact 184.123.665.067',
      '/home 184.123.665.067',
      '/about/2 444.701.448.104',
      '/about 235.313.352.950'
    ]
  end

  let(:result) do
    {
      '/about' => ['235.313.352.950'],
      '/about/2' => ['444.701.448.104'],
      '/contact' => ['184.123.665.067'],
      '/help_page/1' => ['126.318.035.038', '929.398.951.889'],
      '/home' => ['184.123.665.067']
    }
  end

  describe '#call' do
    it 'returns hash with URLs as keys and array of IPs visiting as keys' do
      expect(store).to eq(result)
    end
  end
end
