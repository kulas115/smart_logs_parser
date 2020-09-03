# frozen_string_literal: true

require 'pry'
require_relative 'logs_parser/reader'
require_relative 'logs_parser/line_splitter'
require_relative 'logs_parser/storer'
require_relative 'logs_parser/counter'
require_relative 'logs_parser/sorter'
require_relative 'logs_parser/printer'

module LogsParser
  class Worker
    def call(input_path)
      LogsParser::Reader.new(input_path).call
                        .then { |lines| Storer.new(line_splitter: LogsParser::LineSplitter.new).call(lines) }
                        .then { |visits| Counter.new.call(visits) }
                        .then { |counted_visits| Sorter.new.call(counted_visits) }
                        .then { |sorted_visits| Printer.new.print_total(sorted_visits) }
    end
  end
end
