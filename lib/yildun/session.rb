# frozen_string_literal: true

require "json"
require "fileutils"

module Yildun
  class SessionState
    def self.save(path, tabs:)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, JSON.pretty_generate("tabs" => tabs.map { |tab| {"title" => tab.title, "cwd" => tab.terminal.cwd} }))
    end

    def self.load(path)
      return [] unless File.file?(path)
      JSON.parse(File.read(path)).fetch("tabs", [])
    rescue JSON::ParserError
      []
    end
  end
end
