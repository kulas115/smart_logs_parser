# frozen_string_literal: true

module LogsParser
  class Sorter
    def call(visits)
      visits.sort_by { |_k, v| -v }
    end
  end
end
