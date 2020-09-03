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

module LogsParser
  class Worker
    def initialize(input_path:, reader: nil, storer: nil, line_splitter: nil,
                   counter: nil, sorter: nil, printer: nil)
      @input_path = input_path
      @reader = reader || Reader
      @storer = storer || Storer
      @line_splitter = line_splitter || LineSplitter.new
      @counter = counter || Counter.new
      @sorter = sorter || Sorter.new
      @printer = printer || Printer.new
    end

    def call
      read_file
        .then(&method(:store_file_content))
        .then(&method(:count_visits))
        .then(&method(:sort_visits))
        .then(&method(:sort_visits))
        .then(&method(:print_visits))
    end

    private

    attr_reader :input_path, :reader, :storer, :line_splitter, :counter,
                :sorter, :printer

    def read_file
      reader.new(input_path).call
    end

    def store_file_content(lines)
      storer.new(line_splitter: line_splitter).call(lines)
    end

    def count_visits(visits)
      counter.call(visits)
    end

    def sort_visits(counted_visits)
      sorter.call(counted_visits)
    end

    def print_visits(sorted_visits)
      printer.call(sorted_visits)
    end
  end
end
