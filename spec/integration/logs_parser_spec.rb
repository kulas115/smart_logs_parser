# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe LogsParser do
  it 'read file line by line and returns array of lines' do
    reader = LogsParser::Reader.new('./sample_webserver.log')

    result = [
      '/help_page/1 126.318.035.038',
      '/help_page/1 929.398.951.889',
      '/contact 184.123.665.067',
      '/home 184.123.665.067',
      '/about/2 444.701.448.104',
      '/index 444.701.448.104',
      '/help_page/1 722.247.931.582',
      '/about 061.945.150.735',
      '/help_page/1 646.865.545.408',
      '/home 235.313.352.950',
      '/contact 184.123.665.067',
      '/help_page/1 543.910.244.929',
      '/home 316.433.849.805',
      '/about/2 444.701.448.104',
      '/contact 543.910.244.929',
      '/about 126.318.035.038',
      '/about/2 836.973.694.403',
      '/index 316.433.849.805',
      '/index 802.683.925.780',
      '/help_page/1 929.398.951.889',
      '/contact 555.576.836.194',
      '/about/2 184.123.665.067',
      '/home 444.701.448.104',
      '/index 929.398.951.889',
      '/about 235.313.352.950'
    ]

    expect(reader.call).to eq(result)
  end

  it 'gets lines and returns hash with visits per url' do
    lines = [
      '/help_page/1 126.318.035.038',
      '/help_page/1 929.398.951.889',
      '/contact 184.123.665.067',
      '/home 184.123.665.067',
      '/about/2 444.701.448.104',
      '/index 444.701.448.104',
      '/help_page/1 722.247.931.582',
      '/about 061.945.150.735',
      '/help_page/1 646.865.545.408',
      '/home 235.313.352.950',
      '/contact 184.123.665.067',
      '/help_page/1 543.910.244.929',
      '/home 316.433.849.805',
      '/about/2 444.701.448.104',
      '/contact 543.910.244.929',
      '/about 126.318.035.038',
      '/about/2 836.973.694.403',
      '/index 316.433.849.805',
      '/index 802.683.925.780',
      '/help_page/1 929.398.951.889',
      '/contact 555.576.836.194',
      '/about/2 184.123.665.067',
      '/home 444.701.448.104',
      '/index 929.398.951.889',
      '/about 235.313.352.950'
    ]

    storer = LogsParser::Storer.new.call(lines)

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

    expect(storer).to eq(result)
  end

  it 'splits line into array with URL and IP' do
    line = '/help_page/1 126.318.035.038'

    splitter = LogsParser::LineSplitter.new.call(line)

    expect(splitter).to eq(['/help_page/1', '126.318.035.038'])
  end

  it 'accepts hash of visits and returns new hash with total count of visits' do
    visits = {
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

    counter = LogsParser::Counter.new

    result = {
      '/about' => 3,
      '/about/2' => 4,
      '/contact' => 4,
      '/help_page/1' => 6,
      '/home' => 4,
      '/index' => 4
    }
    
    expect(counter.call(visits)).to eq(result)
  end

  xit 'counts unique visits' do
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

  xit 'counts total visits' do
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

  it 'sort visits ascending' do
    visits = {
      '/about' => 3,
      '/about/2' => 4,
      '/contact' => 4,
      '/help_page/1' => 6,
      '/home' => 4,
      '/index' => 4
    }

    sorter = LogsParser::Sorter.new

    result = [
      ['/about', 3],
      ['/about/2', 4],
      ['/contact', 4],
      ['/home', 4],
      ['/index', 4],
      ['/help_page/1', 6]
    ]

    expect(sorter.call(visits)).to eq(result)
  end

  it 'prints visits array to stdout' do
    visits = [
      ['/about', 3],
      ['/about/2', 4],
      ['/contact', 4],
      ['/home', 4],
      ['/index', 4],
      ['/help_page/1', 6]
    ]
    printer = LogsParser::Printer.new

    result = <<~TEXT
      /about 3 visits
      /about/2 4 visits
      /contact 4 visits
      /home 4 visits
      /index 4 visits
      /help_page/1 6 visits
    TEXT

    expect { printer.print_total(visits) }.to output(result).to_stdout
  end

  it 'accepts the file_path and prints total vists per IP sorted asc' do
    worker = LogsParser::Worker.new

    result = <<~TEXT
      /about 3 visits
      /contact 4 visits
      /home 4 visits
      /about/2 4 visits
      /index 4 visits
      /help_page/1 6 visits
    TEXT

    expect { worker.call('./sample_webserver.log') }.to output(result).to_stdout
  end

  xit 'prints total of visits to the console' do
    parser = LogsParser::Parse.new('./sample_webserver.log')

    count = LogsParser::Counter.new.count(parser.parse)

    sort = LogsParser::Sorter.new.sort(count, :desc)

    printer = LogsParser::Printer.new

    result = <<~TEXT
      /help_page/1 6 visits
      /about 3 visits
      /about/2 4 visits
      /contact 4 visits
      /home 4 visits
      /index 4 visits
    TEXT

    expect { printer.print_total(sort) }.to output(result).to_stdout
  end

  xit 'prints unique visits to the console' do
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
