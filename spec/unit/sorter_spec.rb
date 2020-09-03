# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogsParser::Sorter do
  subject(:sort) { described_class.new }

  let(:visits) do
    {
      '/about' => 3,
      '/about/2' => 4,
      '/contact' => 4,
      '/help_page/1' => 6,
      '/home' => 4,
      '/index' => 4
    }
  end

  it 'sort visits descending' do
    result = [
      ['/help_page/1', 6],
      ['/about/2', 4],
      ['/contact', 4],
      ['/home', 4],
      ['/index', 4],
      ['/about', 3]
    ]

    expect(sort.call(visits)).to eq(result)
  end
end
