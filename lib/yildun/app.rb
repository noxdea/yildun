# frozen_string_literal: true

module Yildun
  class App
    attr_reader :settings, :tabs, :active_index

    def initialize(settings: Settings.new, profile: nil, columns: 80, rows: 24)
      @settings, @tabs, @active_index = settings, [], 0
      open_tab(profile: profile, columns: columns, rows: rows)
    end

    def active_tab = @tabs.fetch(@active_index)
    def active_terminal = active_tab.terminal

    def open_tab(profile: nil, cwd: Dir.pwd, columns: 80, rows: 24)
      profile ||= Yildun.profile(@settings)
      terminal = Terminal.new(command: profile.command, env: profile.env, cwd: profile.cwd || cwd,
        columns: columns, rows: rows, scrollback_limit: @settings.fetch("scrollback_limit"))
      @tabs << Tab.new(terminal, title: profile.name)
      @active_index = @tabs.length - 1
      active_tab
    end

    def close_active
      active_tab.close
      @tabs.delete_at(@active_index)
      return @active_index = 0 if @tabs.empty?

      @active_index = [@active_index, @tabs.length - 1].min
    end

    def next_tab
      @active_index = (@active_index + 1) % @tabs.length if @tabs.any?
    end

    def previous_tab
      @active_index = (@active_index - 1) % @tabs.length if @tabs.any?
    end
  end
end
