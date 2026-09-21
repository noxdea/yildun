# frozen_string_literal: true

require_relative "test_helper"
require "tmpdir"

class SettingsTest < Minitest::Test
  def test_jsonc_layers_merge_without_replacing_nested_defaults
    Dir.mktmpdir do |directory|
      path = File.join(directory, "settings.jsonc")
      File.write(path, <<~JSONC)
        {
          // comments are accepted
          "theme": "default",
          "font": {"size": 16,},
        }
      JSONC
      settings = Yildun::Settings.load(path)
      assert_equal "default", settings["theme"]
      assert_equal 16, settings["font"]["size"]
      assert_equal true, settings["font"]["ligatures"]
    end
  end

  def test_invalid_jsonc_is_reported
    Dir.mktmpdir do |directory|
      path = File.join(directory, "settings.jsonc")
      File.write(path, "{bad")
      assert_raises(ArgumentError) { Yildun::Settings.load(path) }
    end
  end

  def test_comments_inside_strings_are_preserved
    settings = Yildun::Settings.new("url" => "https://example.test/a//b")
    assert_equal "https://example.test/a//b", settings["url"]

    parsed = Yildun::Settings.parse_jsonc('{"url":"https://example.test/a//b",}')
    assert_equal "https://example.test/a//b", parsed.fetch("url")
  end
end
