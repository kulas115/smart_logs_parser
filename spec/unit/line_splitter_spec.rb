# frozen_string_literal: true

RSpec.describe LogsParser::LineSplitter do
  subject(:splitter) { described_class.call(line) }

  context 'when URL and IP are space delimitted' do
    let(:line) { '/contact 184.123.665.067' }

    it { is_expected.to eq(['/contact', '184.123.665.067']) }
  end

  context 'when URL and IP are comma delimitted' do
    let(:line) { '/contact,184.123.665.067' }

    it { is_expected.to eq(['/contact', '184.123.665.067']) }
  end

  context 'when in oposite order IP URL' do
    let(:line) { '184.123.665.067 /contact ' }

    it { is_expected.to eq(['/contact', '184.123.665.067']) }
  end

  context 'with multiple IP in line' do
    let(:line) { '184.123.665.067 /contact 802.683.925.780' }

    it 'parses only first one' do
      expect(splitter).to eq(['/contact', '184.123.665.067'])
    end
  end

  context 'with multiple URLs in line' do
    let(:line) { '/contact 184.123.665.067 /about/2' }

    it 'parses only first one' do
      expect(splitter).to eq(['/contact', '184.123.665.067'])
    end
  end
end
