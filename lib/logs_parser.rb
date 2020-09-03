# frozen_string_literal: true

require 'pry'
require_relative 'logs_parser/reader'
require_relative 'logs_parser/line_splitter'
require_relative 'logs_parser/storer'
require_relative 'logs_parser/counter'

module LogsParser


  class Sorter
    def call(visits, direction = nil)
      if direction == :desc
        visits.sort_by { |_k, v| -v }
      else
        visits.sort_by { |_k, v| v }
      end
    end
  end

  class Printer
    def print_total(array)
      array.each do |small_array|
        puts "#{small_array[0]} #{small_array[1]} visits"
      end
    end

    def print_unique(array)
      array.each do |small_array|
        puts "#{small_array[0]} #{small_array[1]} unique views"
      end
    end
  end

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
