# frozen_string_literal: true

require_relative "test_helper"

class TerminalTest < Minitest::Test
  FakeSession = Struct.new(:screen, :vt) do
    Command = Struct.new(:exit_status)

    def input(value) = value
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
  end
end
