# frozen_string_literal: true

module LogsParser
  # :nodoc:
  class LineSplitter
    URL_REGEXP = %r{/[/_0-9a-z]*}.freeze
    IP_REGEXP  = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/.freeze

    private_constant :URL_REGEXP, :IP_REGEXP

    def call(line)
      [line[URL_REGEXP], line[IP_REGEXP]]
    end
  end
end
