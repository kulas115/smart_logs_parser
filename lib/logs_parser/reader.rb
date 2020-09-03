# frozen_string_literal: true

module LogsParser
  class Reader < LogsParserService
    def call(file_path)
      raise_error_if_file_does_not_exist(file_path)

      file_read(file_path)
    end

    private

    def raise_error_if_file_does_not_exist(file_path)
      raise "Provided file under #{file_path} does not exist" unless File.exist?(file_path)
    end

    def file_read(file_path)
      lines = []

      File.foreach(file_path) do |line|
        lines << line.strip
      end

      lines
    end
  end
end
