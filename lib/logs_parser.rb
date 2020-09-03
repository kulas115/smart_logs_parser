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
    def initialize(input_path:, reader: nil, storer: nil, line_splitter: nil, counter: nil, sorter: nil, printer: nil )
      @input_path = input_path
      @reader = reader || Reader
      @storer = storer || Storer
      @line_splitter = line_splitter || LineSplitter.new
      @counter = counter || Counter.new
      @sorter = sorter || Sorter.new
      @printer = printer || Printer.new
    end

    def call(input_path)
      LogsParser::Reader.new(input_path).call
                        .then { |lines| Storer.new(line_splitter: LogsParser::LineSplitter.new).call(lines) }
                        .then { |visits| Counter.new.call(visits) }
                        .then { |counted_visits| Sorter.new.call(counted_visits) }
                        .then { |sorted_visits| Printer.new.call(sorted_visits) }
    end
  end
end
