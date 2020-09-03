# frozen_string_literal: true

module LogsParser
  # :nodoc:
  class Reader
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      raise_error_if_file_does_not_exist

      file_read
    end

    private

    attr_reader :file_path

    def raise_error_if_file_does_not_exist
      raise "Provided file under #{file_path} does not exist" unless File.exist?(file_path)
    end

    def file_read
      lines = []

      File.foreach(file_path) do |line|
        lines << line.strip
      end

      lines
    end
  end
end
