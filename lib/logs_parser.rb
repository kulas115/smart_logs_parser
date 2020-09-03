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
    def initialize(input_path:, reader: nil, storer: nil, line_splitter: nil, counter: nil, sorter: nil, printer: nil)
      @input_path = input_path
      @reader = reader || Reader
      @storer = storer || Storer
      @line_splitter = line_splitter || LineSplitter.new
      @counter = counter || Counter.new
      @sorter = sorter || Sorter.new
      @printer = printer || Printer.new
    end

    def call
      reader.new(input_path).call
            .then { |lines| storer.new(line_splitter: line_splitter).call(lines) }
            .then { |visits| counter.call(visits) }
            .then { |counted_visits| sorter.call(counted_visits) }
            .then { |sorted_visits| printer.call(sorted_visits) }
    end

    private

    attr_reader :input_path, :reader, :storer, :line_splitter, :counter, :sorter, :printer
  end
end
