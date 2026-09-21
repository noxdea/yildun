# frozen_string_literal: true

require_relative "test_helper"

class LinksTest < Minitest::Test
  def test_open_rejects_unsafe_schemes_and_allows_injected_opener
    assert_raises(ArgumentError) { Yildun::Links.open("file:///etc/passwd") }
    opened = nil
    Yildun::Links.open("https://example.test", opener: ->(url) { opened = url })
    assert_equal "https://example.test", opened
  end
end
