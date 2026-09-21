# frozen_string_literal: true

require_relative "test_helper"

class TerminalTest < Minitest::Test
  FakeSession = Struct.new(:screen, :vt) do
    Command = Struct.new(:exit_status)

    def input(value) = value
    def paste(value) = value
    def key(name, **modifiers) = [name, modifiers]
    def mouse(**event) = event
    def pump(timeout:) = false
    def cwd = "/tmp"
    def close = true
    def resize(columns:, rows:) = [columns, rows]
    def commands = [Command.new(0), Command.new(1)]
  end

  def test_terminal_delegates_search_and_focus
    grid = Tarazed::Grid.new(columns: 8, rows: 2)
    vt = Tarazed::VT.new(grid)
    vt.feed("hello")
    terminal = Yildun::Terminal.new(command: ["sh"], session: FakeSession.new(grid, vt))
    assert_equal "hello", terminal.screen.lines.first
    assert_equal [], terminal.search("missing")
    assert_equal "", terminal.focus(active: true)
    assert_equal 1, terminal.failed_commands.length
    assert_equal [8, 2], terminal.resize(columns: 8, rows: 2)
    assert_equal "hello", terminal.selection([0, 0], [5, 0])
    assert_equal "paste", terminal.paste("paste")
    assert_equal ["enter", {shift: true}], terminal.key("enter", shift: true)
    assert_equal({button: :left, column: 1, row: 0}, terminal.mouse(button: :left, column: 1, row: 0))
  end

  def test_command_output_and_search
    grid = Tarazed::Grid.new(columns: 8, rows: 2)
    vt = Tarazed::VT.new(grid)
    vt.feed("output")
    command = Tarazed::Command.new(id: 1, prompt_row: 0, input: "echo output", output_range: 0..0,
      exit_status: 0, started_at: Time.now, finished_at: Time.now, cwd: "/tmp")
    session = FakeSession.new(grid, vt)
    session.define_singleton_method(:commands) { [command] }
    terminal = Yildun::Terminal.new(command: ["sh"], session: session)
    assert_includes terminal.command_output(command), "output"
    assert_equal [command], terminal.search_commands("ECHO")
  end
end
