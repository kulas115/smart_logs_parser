# frozen_string_literal: true

require 'pry'

module LogsParser
  class Reader
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      lines = []

      File.foreach(@file_path) do |line|
        lines << line.strip
      end

      lines
    end
  end

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

  class LineSplitter
    URL_REGEXP = %r{/[/_0-9a-z]*}.freeze
    IP_REGEXP  = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/.freeze

    private_constant :URL_REGEXP, :IP_REGEXP

    def call(line)
      [line[URL_REGEXP], line[IP_REGEXP]]
    end
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
      Reader.new(input_path).call
            .then { |lines| Storer.new(line_splitter: LineSplitter.new).call(lines) }
            .then { |visits| Counter.new.call(visits) }
            .then { |counted_visits| Sorter.new.call(counted_visits) }
            .then { |sorted_visits| Printer.new.print_total(sorted_visits) }
    end
  end
end
