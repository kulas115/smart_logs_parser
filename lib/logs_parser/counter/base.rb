# frozen_string_literal: true

module LogsParser
  module Counter
    class Base < LogsParserService
      def call(visits)
        visits.each_with_object({}) do |(page_url, ips_array), views|
          views[page_url] = count(ips_array)
        end
      end

      private

      def count(_ips_array)
        raise NotImplementedError, :count
      end
    end
  end
end
