# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe LogsParser do
  it 'reads file line by line and outputs hash or arrays' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    result = {
      '/help_page/1' =>
        ['126.318.035.038',
         '929.398.951.889',
         '722.247.931.582',
         '646.865.545.408',
         '543.910.244.929',
         '929.398.951.889'],
      '/contact' =>
        ['184.123.665.067',
         '184.123.665.067',
         '543.910.244.929',
         '555.576.836.194'],
      '/home' =>
        ['184.123.665.067',
         '235.313.352.950',
         '316.433.849.805',
         '444.701.448.104'],
      '/about/2' =>
        ['444.701.448.104',
         '444.701.448.104',
         '836.973.694.403',
         '184.123.665.067'],
      '/index' =>
        ['444.701.448.104',
         '316.433.849.805',
         '802.683.925.780',
         '929.398.951.889'],
      '/about' =>
      ['061.945.150.735',
       '126.318.035.038',
       '235.313.352.950']
    }

    expect(parser.parse).to eq(result)
  end

  it 'counts unique visits' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse, :uniq)

    result = {
      '/about' => 3,
      '/about/2' => 3,
      '/contact' => 3,
      '/help_page/1' => 5,
      '/home' => 4,
      '/index' => 4
    }

    expect(count).to eq(result)
  end

  it 'counts total visits' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse)

    result = {
      '/about' => 3,
      '/about/2' => 4,
      '/contact' => 4,
      '/help_page/1' => 6,
      '/home' => 4,
      '/index' => 4
    }

    expect(count).to eq(result)
  end

  it 'sort visits descending' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse)

    sort = LogsParser::Sorter.new.sort(count, :desc)

    result = [
      ['/help_page/1', 6],
      ['/contact', 4],
      ['/home', 4],
      ['/about/2', 4],
      ['/index', 4],
      ['/about', 3]
    ]

    expect(sort).to eq(result)
  end

  it 'prints total of visits to the console' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse)

    sort = LogsParser::Sorter.new.sort(count, :desc)

    printer = LogsParser::Printer.new

    result = <<~TEXT
      /help_page/1 6 visits
      /contact 4 visits
      /home 4 visits
      /about/2 4 visits
      /index 4 visits
      /about 3 visits
    TEXT

    expect { printer.print_total(sort) }.to output(result).to_stdout
  end

  it 'prints unique visits to the console' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse, :uniq)

    sort = LogsParser::Sorter.new.sort(count, :desc)

    printer = LogsParser::Printer.new

    result = <<~TEXT
      /help_page/1 5 unique views
      /home 4 unique views
      /index 4 unique views
      /contact 3 unique views
      /about/2 3 unique views
      /about 3 unique views
    TEXT

    expect { printer.print_unique(sort) }.to output(result).to_stdout
  end
end
# rubocop:enable all
