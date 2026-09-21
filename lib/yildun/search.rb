# frozen_string_literal: true

module Yildun
  class Search
    def initialize(terminal) = @terminal = terminal
    def call(query, regex: false) = @terminal.screen.search(query, regex: regex)
  end
end
