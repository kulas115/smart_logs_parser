# frozen_string_literal: true

module LogsParser
  class Counter
    def call(visits, ordering = nil)
      visits.each_with_object({}) do |(page_url, ips_array), views|
        views[page_url] = if ordering == :uniq
                            ips_array.uniq.size
                          else
                            ips_array.size
                          end
      end
    end
  end
end
