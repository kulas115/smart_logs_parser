# frozen_string_literal: true

require 'pry'

module LogsParser
  class Parse
    def initialize(file_path)
      @file_path = file_path
    end

    def parse
      views = Hash.new { |h, k| h[k] = [] }

      File.foreach(@file_path) do |file_line|
        page_url, page_ip = file_line.split(' ')
        views[page_url] << page_ip
      end

      views
    end
  end

  class Counter
    def count(hash, ordering = nil)
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
    def sort(visits, direction)
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
end
