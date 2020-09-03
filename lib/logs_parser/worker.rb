# frozen_string_literal: true

# rubocop:disable Metrics/ParameterLists
module LogsParser
  class Worker
    def initialize(input_path:, reader: nil, storer: nil, line_splitter: nil,
                   counter: nil, sorter: nil, printer: nil)
      @input_path = input_path
      @reader = reader || Reader
      @storer = storer || Storer
      @line_splitter = line_splitter || LineSplitter
      @counter = counter || Counter::Total
      @sorter = sorter || Sorter
      @printer = printer || Printer::Total
    end

    def call
      read_file
        .then(&method(:store_file_content))
        .then(&method(:count_visits))
        .then(&method(:sort_visits))
        .then(&method(:print_visits))
    end

    private

    attr_reader :input_path, :reader, :storer, :line_splitter, :counter,
                :sorter, :printer

    def read_file
      reader.call(input_path)
    end

    def store_file_content(lines)
      storer.new(line_splitter: line_splitter.new).call(lines)
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
# rubocop:enable all
