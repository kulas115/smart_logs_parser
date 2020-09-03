# frozen_string_literal: true

module LogsParser
  module Printer
    class Base < LogsParserService
      def call(visits_array)
        visits_array.each(&method(:print))
      end

      private

      def print(_visit)
        raise NotImplementedError, :count
      end
    end
  end
end
