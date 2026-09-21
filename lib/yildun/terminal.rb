# frozen_string_literal: true

tarazed_path = ENV["TARAZED_PATH"]
tarazed_root = File.expand_path("..", __dir__)
tarazed_path ? require(File.expand_path("lib/tarazed", File.expand_path(tarazed_path, tarazed_root))) : require("tarazed")

module Yildun
  class Terminal
    attr_reader :session

    def initialize(command:, env: {}, cwd: Dir.pwd, columns: 80, rows: 24, scrollback_limit: 10_000, session: nil)
      @session = session || Tarazed::Session.new(command: command, env: env, cwd: cwd, columns: columns, rows: rows,
        scrollback_limit: scrollback_limit)
    end

    def screen = @session.screen
    def cwd = @session.cwd
    def commands = @session.commands
    def failed_commands = commands.select { |command| command.exit_status != 0 }
    def input(bytes) = @session.input(bytes)
    def pump(timeout: 0) = @session.pump(timeout: timeout)
    def resize(columns:, rows:) = @session.resize(columns: columns, rows: rows)
    def focus(active:) = @session.vt.focus(active: active)
    def search(query, regex: false) = screen.search(query, regex: regex)

    def previous_command
      @command_index = [(@command_index || commands.length) - 1, 0].max
      commands[@command_index]
    end

    def next_command
      @command_index = [(@command_index || -1) + 1, commands.length - 1].min
      commands[@command_index]
    end

    def last_command = commands.last

    def close = @session.close
  end
end
