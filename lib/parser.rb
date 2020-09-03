# frozen_string_literal: true

require_relative 'environment'

class Parser
  SCHEMES = {
    total: {
      counter: LogsParser::Counter::Total,
      printer: LogsParser::Printer::Total
    },
    unique: {
      counter: LogsParser::Counter::Unique,
      printer: LogsParser::Printer::Unique
    }
  }.freeze

  def initialize(file_path:, schema: nil)
    @file_path = file_path
    @schema = schema
  end

  def call
    selected_schema = SCHEMES[schema]

    LogsParser::Worker.new(input_path: file_path,
                           counter: selected_schema&.dig(:counter),
                           printer: selected_schema&.dig(:printer))
                      .call
  end

  private

  attr_reader :file_path, :schema
end
