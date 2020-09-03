# frozen_string_literal: true

require_relative 'logs_parser'

class Parser
  SCHEMES = {
    total: {

    },
    unique: {

    }
  }
  
  def call(file_path)
    LogsParser::Worker.new.call(file_path)
  end
end
