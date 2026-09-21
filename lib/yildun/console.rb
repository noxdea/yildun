# frozen_string_literal: true

require "io/console"

module Yildun
  class Console
    def initialize(terminal, input: $stdin, output: $stdout)
      @terminal, @input, @output = terminal, input, output
    end

    def run
      return render unless @input.tty? && @output.tty? && @input.respond_to?(:raw)

      @input.raw do
        @output.write("\e[?25l")
        loop do
          resize
          @terminal.pump(timeout: 0.02)
          render
          break unless @terminal.session.alive?
          next unless IO.select([@input], nil, nil, 0.02)

          @terminal.input(@input.read_nonblock(4096))
        rescue IO::WaitReadable
          retry
        rescue EOFError, Errno::EIO
          break
        end
      ensure
        @output.write("\e[0m\e[?25h\e[H\e[2J")
      end
    end

    def render
      @output.write("\e[H")
      @terminal.screen.lines.each { |line| @output.write("\e[2K#{line}\r\n") }
      @output.flush
    end

    private

    def resize
      rows, columns = @output.winsize
      @terminal.resize(columns: columns, rows: rows)
    rescue SystemCallError, NoMethodError
      nil
    end
  end
end
