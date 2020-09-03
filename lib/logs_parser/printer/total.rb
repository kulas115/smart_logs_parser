# frozen_string_literal: true

module LogsParser
  module Printer
    class Total < Base
      private

      def print(visit)
        puts "#{visit[0]} #{visit[1]} visits"
      end
    end
  end
end
