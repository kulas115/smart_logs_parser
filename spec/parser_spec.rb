# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Parser do
  it 'is expected to call LogsParser class passing file\'s path' do
    file_path = './sample_webserver.log'

    allow(LogsParser::Worker).to receive_message_chain(:new, :call)

    expect(LogsParser::Worker).to receive_message_chain(:new, :call)

    Parser.new.call(file_path)
  end
end
