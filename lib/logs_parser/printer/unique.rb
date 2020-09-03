# frozen_string_literal: true

module LogsParser
  module Printer
    class Unique < Base
      private

      def print(visit)
        puts "#{visit[0]} #{visit[1]} unique views"
      end
    end
  end
end
