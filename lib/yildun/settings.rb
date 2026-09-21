# frozen_string_literal: true

require "json"

module Yildun
  class Settings
    DEFAULTS = {
      "font" => {"family" => "JetBrains Mono", "size" => 13, "ligatures" => true, "line_height" => 1.2},
      "theme" => "tokyo-night",
      "cursor" => {"shape" => "block", "blink" => true},
      "background_opacity" => 1.0,
      "scrollback_limit" => 10_000,
      "shell_integration" => true,
      "profiles" => {"default" => {"command" => [ENV.fetch("SHELL", "sh"), "-l"], "env" => {}}},
      "default_profile" => "default",
      "links" => {"file_line" => {"pattern" => "([\\w./-]+):(\\d+)", "action" => "open_editor"}},
      "keymap" => {"cmd+t" => "tab.new", "cmd+d" => "pane.split_right", "cmd+f" => "search.open"}
    }.freeze

    attr_reader :values

    def initialize(values = {})
      @values = deep_merge(DEFAULTS, stringify_keys(values)).freeze
    end

    def [](key) = @values.fetch(key.to_s)
    def fetch(key, default = nil) = @values.fetch(key.to_s, default)
    def profile(name = @values.fetch("default_profile")) = @values.fetch("profiles").fetch(name.to_s)

    def self.load(path = default_path)
      return new unless File.file?(path)
      new(parse_jsonc(File.read(path, encoding: "UTF-8")))
    rescue JSON::ParserError, EncodingError => error
      raise ArgumentError, "invalid settings: #{error.message}"
    end

    def self.default_path
      root = ENV["XDG_CONFIG_HOME"] || File.join(Dir.home, ".config")
      File.join(root, "yildun", "settings.jsonc")
    end

    def self.parse_jsonc(text)
      JSON.parse(text.gsub(%r{//.*$}, "").gsub(/,\s*([}\]])/, '\\1'))
    end

    private

    def stringify_keys(value)
      case value
      when Hash then value.to_h { |key, item| [key.to_s, stringify_keys(item)] }
      when Array then value.map { |item| stringify_keys(item) }
      else value
      end
    end

    def deep_merge(left, right)
      left.merge(right) do |_key, old, value|
        old.is_a?(Hash) && value.is_a?(Hash) ? deep_merge(old, value) : value
      end
    end
  end
end
