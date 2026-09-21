# frozen_string_literal: true

module Yildun
  module Links
    module_function

    def at(screen, row, column, cwd: Dir.pwd)
      screen.links(row).find { |link| column.between?(link[:column], link[:end_column] - 1) } ||
        screen.file_paths(row, cwd: cwd).find { |link| column == link[:column] }
    end

    def open(url, opener: nil)
      raise ArgumentError, "only http(s) and mailto links are allowed" unless url.to_s.match?(/\A(?:https?|mailto):/i)
      return opener.call(url) if opener
      command = RUBY_PLATFORM.match?(/darwin/) ? "open" : "xdg-open"
      Process.spawn(command, url.to_s, out: File::NULL, err: File::NULL)
    end
  end
end
