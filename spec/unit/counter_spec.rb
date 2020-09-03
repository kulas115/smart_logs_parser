# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Counter do
  subject(:count) { described_class.new }

  let(:visits) do
    {
      '/help_page/1' =>
        ['126.318.035.038',
         '126.318.035.038',
         '126.318.035.038',
         '929.398.951.889'],
      '/contact' =>
        ['184.123.665.067',
         '184.123.665.067',
         '543.910.244.929',
         '555.576.836.194'],
      '/index' =>
        ['444.701.448.104',
         '316.433.849.805',
         '316.433.849.805',
         '929.398.951.889'],
      '/about' =>
      ['061.945.150.735',
       '126.318.035.038',
       '235.313.352.950']
    }
  end

  it 'accepts hash of visits and returns new hash with total count of visits' do
    result = {
      '/about' => 3,
      '/contact' => 4,
      '/help_page/1' => 4,
      '/index' => 4
    }

    expect(count.call(visits)).to eq(result)
  end

  it 'accepts hash of visits and returns new hash with uniq count of visits' do
    result = {
      '/about' => 3,
      '/contact' => 3,
      '/help_page/1' => 2,
      '/index' => 3
    }

    expect(count.call(visits, :uniq)).to eq(result)
  end
end
