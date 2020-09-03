# frozen_string_literal: true

require 'pry'
require_relative 'logs_parser/reader'
require_relative 'logs_parser/line_splitter'
require_relative 'logs_parser/storer'
require_relative 'logs_parser/counter/base'
require_relative 'logs_parser/counter/total'
require_relative 'logs_parser/counter/unique'
require_relative 'logs_parser/sorter'
require_relative 'logs_parser/printer/base'
require_relative 'logs_parser/printer/total'
require_relative 'logs_parser/printer/unique'

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
