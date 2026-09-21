# frozen_string_literal: true

module Yildun
  class Tab
    attr_reader :title, :terminal

    def initialize(terminal, title: nil)
      @terminal, @title = terminal, (title || terminal.cwd)
    end

    def close = @terminal.close
  end
end
