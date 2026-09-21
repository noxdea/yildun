<h1 align="center">Yildun</h1>

<p align="center"><strong>A pure Ruby terminal application shell with profiles, tabs, and testable sessions.</strong></p>

<p align="center">
  <a href="https://rubygems.org/gems/yildun"><img src="https://img.shields.io/gem/v/yildun" alt="Gem version"></a>
  <a href="https://github.com/noxdea/yildun/actions/workflows/main.yml"><img src="https://github.com/noxdea/yildun/actions/workflows/main.yml/badge.svg" alt="CI status"></a>
  <img src="https://img.shields.io/badge/Ruby-3.1%2B-cc342d" alt="Ruby 3.1 or newer">
  <a href="LICENSE.txt"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT license"></a>
</p>

<p align="center">
  <a href="#features">Features</a> ·
  <a href="#installation">Installation</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#headless-sessions">Headless sessions</a> ·
  <a href="#configuration">Configuration</a>
</p>

---

Yildun is a terminal application shell built on
[Tarazed](https://github.com/noxdea/tarazed). It manages profiles, tabs, pane
state, scrollback search, and links while keeping the terminal session
available for scripted integration tests. The name comes from δ Ursae Minoris
and the Turkish *yıldız*, “star.”

## Features

- Tarazed-backed terminal sessions with profiles and tabs
- Pane state, configurable keymaps, scrollback search, and OSC 8 links
- JSONC settings with fail-fast validation
- Headless command, script, and expected-screen modes for testing
- Pure Ruby; no WebView, JavaScript engine, SSH client, or multiplexer

## Installation

Add `gem "yildun"` to your Gemfile and run `bundle install`, or install directly:

```sh
gem install yildun
```

Requires Ruby 3.1 or newer. The gem installs its compatible Tarazed dependency.

## Quick start

Launch the terminal from a TTY:

```sh
yildun
```

Run a specific shell command:

```sh
yildun --command 'printf "hello\n"'
```

Interactive mode needs terminal input and output. In a script or CI job, use
`--headless` instead.

## Headless sessions

```sh
yildun --headless --command 'printf "hello\n"'
```

`--headless` prints the final screen and exits. `--script PATH` sends file
contents to the session, while `--expect PATH` compares the final screen
with a fixture. Use `--columns`, `--rows`, and `--timeout` when a test needs
specific dimensions or more time.

## Configuration

Yildun reads `$XDG_CONFIG_HOME/yildun/settings.jsonc`, or
`~/.config/yildun/settings.jsonc` when `XDG_CONFIG_HOME` is unset.
For example:

```jsonc
{
  "theme": "tokyo-night",
  "scrollback_limit": 10000,
  "profiles": {
    "default": {
      "command": ["sh", "-l"],
      "env": {}
    }
  }
}
```

Settings merge with built-in defaults. Invalid JSONC raises a clear error
instead of silently replacing the active profile. See the
[cell-rendering](docs/adr/001-cell-rendering.md) and
[shell-integration](docs/adr/002-shell-integration.md) decisions.

## Development

```sh
bundle install
bundle exec rake test
bundle exec rbs -I sig validate
```

## License

[MIT](LICENSE.txt)
