# frozen_string_literal: true

require_relative "test_helper"

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
end
