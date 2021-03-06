# frozen_string_literal: true

RSpec.describe LogsParser::Counter::Base do
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

  describe '#call' do
    subject(:count) { described_class.call(visits) }

    it 'raises NotImplementedError' do
      expect { count }.to raise_error(NotImplementedError)
    end
  end
end
