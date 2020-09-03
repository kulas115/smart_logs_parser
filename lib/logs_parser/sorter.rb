# frozen_string_literal: true

module LogsParser
  class Sorter
    def call(visits, direction = nil)
      if direction == :asc
        visits.sort_by { |_k, v| v }
      else
        visits.sort_by { |_k, v| -v }
      end
    end
  end
end
