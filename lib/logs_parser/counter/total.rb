# frozen_string_literal: true

module LogsParser
  module Counter
    class Total < Base
      private

      def count(ips_array)
        ips_array.size
      end
    end
  end
end
