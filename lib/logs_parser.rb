# frozen_string_literal: true

require 'pry'
require_relative 'logs_parser/reader'
require_relative 'logs_parser/line_splitter'

module LogsParser
  class Storer
    def initialize(line_splitter: nil)
      @storage = Hash.new { [] }
      @line_splitter = line_splitter || LineSplitter.new
    end

    def call(lines)
      lines.each_with_object(storage) do |line, visits_storage|
        page_url, page_ip = line_splitter.call(line)
        visits_storage[page_url] <<= page_ip
      end
    end

    private

    attr_reader :storage, :line_splitter
  end

  class Counter
    def call(hash, ordering = nil)
      hash.each_with_object({}) do |(page_url, ips_array), views|
        views[page_url] = if ordering == :uniq
                            ips_array.uniq.size
                          else
                            ips_array.size
                          end
      end
    end
  end

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
