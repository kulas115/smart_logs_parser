require_relative 'logs_parser'

class Parser
  def call(file_path)
    LogsParser::Worker.new.call(file_path)
  end
end
