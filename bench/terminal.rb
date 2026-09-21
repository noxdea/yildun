# frozen_string_literal: true

require "benchmark"
require_relative "../lib/yildun"
require "tarazed"

grid = Tarazed::Grid.new(columns: 240, rows: 80)
vt = Tarazed::VT.new(grid)
payload = ("x" * 239 + "\r\n") * 80
elapsed = Benchmark.realtime { vt.feed(payload) } * 1000
abort "terminal update exceeded 4 ms: #{elapsed.round(2)}" if ENV["BUDGET"] == "1" && elapsed > 4
puts "terminal parse: #{elapsed.round(2)} ms"
