# frozen_string_literal: true

require 'spec_helper'
RSpec.describe LogsParser do
  it 'accepts the file_path and prints total vists per IP sorted desc' do
    sample_log_path = './sample_webserver.log'

    worker = LogsParser::Worker.new

    result = <<~TEXT
      /help_page/1 6 visits
      /contact 4 visits
      /home 4 visits
      /about/2 4 visits
      /index 4 visits
      /about 3 visits
    TEXT

    expect { worker.call(sample_log_path) }.to output(result).to_stdout
  end
end
