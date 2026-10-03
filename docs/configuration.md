---
layout: guide
title: Configuration
description: Configure the default shell profile, environment, and scrollback with JSONC.
---

Yildun loads one JSONC settings file at startup and merges it with built-in defaults. JSONC accepts `//` comments, `/* block comments */`, and trailing commas.

## Find the settings file

The executable reads:

- `$XDG_CONFIG_HOME/yildun/settings.jsonc` when `XDG_CONFIG_HOME` is set.
- `~/.config/yildun/settings.jsonc` otherwise.

A missing file uses the defaults. There is no project-local settings file, `--config` option, or live reload. Restart Yildun after editing settings. An explicitly supplied path is available to Ruby callers through `Yildun::Settings.load(path)`.

For the default location, create the directory and edit its file:

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/yildun"
```

Keep `XDG_CONFIG_HOME` unset or set to a nonempty directory path. Yildun treats an explicitly empty value as a configured path rather than falling back to `~/.config`.

## Choose a shell profile

Save the following as `settings.jsonc` in that directory:

```jsonc
{
  // Pick the profile used by `yildun` without --command.
  "default_profile": "work",
  "scrollback_limit": 5000,
  "profiles": {
    "work": {
      "command": ["sh", "-l"],
      "env": {
        "YILDUN_GREETING": "Hello from my work profile",
      },
    },
  },
}
```

Start `yildun`, then type this at its shell prompt:

```sh
printf '%s\n' "$YILDUN_GREETING"
```

You should see `Hello from my work profile`. A login shell can change its environment through its own startup files, so check those files if the value differs.

The `command` array contains the executable followed by its arguments. For example, use `["bash", "-l"]`, `["zsh", "-l"]`, or, on Windows, `["cmd.exe"]`, when that shell is installed. The default is `[ENV["SHELL"], "-l"]`, with `sh` substituted when `$SHELL` is unset.

An optional profile `cwd` sets the launch directory. Use an existing path, such as `"cwd": "/home/alex/project"`. Settings strings do not expand `~`, `$HOME`, or other shell variables. When `cwd` is absent, the executable starts the shell in its own current directory.

## How settings merge

Loading follows these rules:

1. Start with built-in defaults.
2. Recursively merge objects from the settings file; supplied scalar values and arrays replace their defaults.
3. Without `--command`, resolve the profile named by `default_profile`.
4. With `--command`, skip named-profile resolution and use a temporary command profile with no profile environment overrides and the current launch directory.

Adding `profiles.work` keeps the built-in `profiles.default`. An empty `env` object does not remove inherited entries when overriding an existing profile. Use a complete executable-and-arguments array when changing a profile's command; the array replaces the previous array.

There is no `--profile` selector in the executable. Select a different profile by changing `default_profile`; Ruby callers can select a named profile with `Yildun.profile(settings, name)`.

## Settings that affect the console

| Setting | Default | Effect |
| --- | --- | --- |
| `default_profile` | `"default"` | Selects the profile used at startup. |
| `profiles` | A login-shell profile | Defines commands, environment overrides, and optional working directories. |
| `scrollback_limit` | `10000` | Sets the session's retained scrollback row limit; use a nonnegative integer. |

The session retains scrollback, but the console does not expose a scrollback browser. Headless output also includes only the visible screen.

## Appearance and other library settings

Built-in settings also include `font`, `theme`, `cursor`, `background_opacity`, `shell_integration`, `links`, and `keymap`. The current console does not apply font, theme, cursor, or opacity settings, dispatch keymap actions, expose link opening, or automatically inject shell-integration scripts. These entries must be used by an embedding application to affect its interface.

In particular, setting `"shell_integration": true` does not by itself add command-history markers to your shell, and the default `cmd+t`, `cmd+d`, and `cmd+f` bindings do not open console tabs, panes, or search. See [Interactive usage](usage.md) for the available controls.

## Fix invalid settings

Malformed JSONC raises `ArgumentError` with an `invalid settings` message. Yildun does not silently discard that file. Make the document a JSON object, correct its syntax, and restart.

The loader is not a full settings-schema validator. A missing profile name, wrong value type, invalid terminal limit, nonexistent executable, or unavailable working directory may fail later during startup. Check the profile name and keep the value types shown in the examples.
