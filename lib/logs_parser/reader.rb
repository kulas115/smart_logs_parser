# frozen_string_literal: true

module LogsParser
  # :nodoc:
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
end
