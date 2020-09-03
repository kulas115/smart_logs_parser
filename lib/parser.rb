# frozen_string_literal: true

require_relative 'environment'

class Parser
  SCHEMES = {
    total: {

    },
    unique: {

    }
  }.freeze

  def call(file_path)
    LogsParser::Worker.new.call(file_path)
  end
end
