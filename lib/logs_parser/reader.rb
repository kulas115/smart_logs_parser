# frozen_string_literal: true

module LogsParser
  class Reader < LogsParserService
    def call(file_path)
      raise_error(file_path) unless File.exist?(file_path)

      file_read(file_path)
    end

    private

    def raise_error(file_path)
      raise Errno::ENOENT, "Provided file under #{file_path} does not exist"
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
