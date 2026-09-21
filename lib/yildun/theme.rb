# frozen_string_literal: true

module Yildun
  Theme = Data.define(:name, :background, :foreground, :cursor, :selection)
  THEMES = {
    "tokyo-night" => Theme.new("tokyo-night", "#1a1b26", "#c0caf5", "#c0caf5", "#33467c"),
    "default" => Theme.new("default", "#111318", "#dddddd", "#ffffff", "#334455")
  }.freeze

  module_function

  def theme(name) = THEMES.fetch(name.to_s, THEMES.fetch("default"))
end
