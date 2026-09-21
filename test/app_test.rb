# frozen_string_literal: true

require_relative "test_helper"
require "stringio"

class AppTest < Minitest::Test
  FakeTerminal = Struct.new(:cwd) do
    def close = true
  end

  def test_close_last_tab_leaves_a_recoverable_empty_app
    app = Yildun::App.allocate
    app.instance_variable_set(:@tabs, [Yildun::Tab.new(FakeTerminal.new("/tmp"))])
    app.instance_variable_set(:@active_index, 0)
    app.close_active
    assert_empty app.tabs
    assert_equal 0, app.active_index
    assert_nil app.next_tab
  end

  def test_split_wraps_existing_tab_and_adds_new_tab
    first = Object.new
    second = Object.new
    pane = Yildun::Pane.new(first)

    pane.split(second)

    refute pane.leaf?
    assert_equal [first, second], pane.children.map { |child| child.children.first }
  end

  def test_console_renders_grid_without_a_tty
    output = StringIO.new
    terminal = Struct.new(:screen).new(Struct.new(:lines).new(["hello"]))
    Yildun::Console.new(terminal, input: StringIO.new, output: output).render
    assert_includes output.string, "hello"
  end
end
