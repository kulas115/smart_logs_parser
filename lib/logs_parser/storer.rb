# frozen_string_literal: true

module LogsParser
  # :nodoc:
  class Storer < LogsParserService
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
end
