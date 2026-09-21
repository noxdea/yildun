# Yildun

Yildun (δ Ursae Minoris, from Turkish *yıldız*, “star”) is a pure Ruby
terminal application shell backed by the Tarazed terminal emulator.

It provides profiles, tabs, pane state, keymaps, scrollback search, OSC 8
links, and a deterministic headless mode for integration tests. It does not
embed an SSH client, multiplexer, JavaScript engine, or WebView.

## Installation

```sh
gem install yildun
```

## Headless sessions

```sh
yildun --headless --command 'printf "hello\\n"'
```

Configuration is read from `$XDG_CONFIG_HOME/yildun/settings.jsonc` (or
`~/.config/yildun/settings.jsonc`). Settings are fail-safe: malformed files
raise a clear error instead of silently changing the shell profile.

## Development

```sh
bundle install
bundle exec rake test
bundle exec rbs -I sig validate
```
