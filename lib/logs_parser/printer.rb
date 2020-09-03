# frozen_string_literal: true

module LogsParser
  class Printer
    def call(visits_array, count = nil)
      visits_array.each do |visit|
        if count == :uniq
          puts "#{visit[0]} #{visit[1]} unique views"
        else
          puts "#{visit[0]} #{visit[1]} visits"
        end
      end
    end
  end
end
