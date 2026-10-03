---
layout: guide
title: Interactive usage
description: Run a shell, send terminal input, and understand the current console's controls.
---

The `yildun` command opens one interactive terminal session. It sends your input to the child shell and redraws the session's visible screen.

## Start a shell or a command

Use the configured default profile:

```sh
yildun
```

Or launch a command instead of that profile:

```sh
yildun --command 'sh'
```

`--command` creates a temporary command profile with no profile environment overrides and uses the directory from which you launched Yildun. It replaces the selected profile's command, environment overrides, and working directory; other settings, such as the scrollback limit, still load.

For a source checkout, run `bundle install` and use `bundle exec exe/yildun` from the repository directory.

## Type and navigate

Yildun forwards the bytes from your outer terminal to the session. Editing behavior, history, completion, and interrupt handling depend on the shell or program running inside it.

| Input | Usual shell behavior |
| --- | --- |
| Enter | Submit the current command. |
| Backspace | Edit the current input. |
| Up / Down | Browse shell history, if supported by the shell. |
| Tab | Complete a command or filename, if supported by the shell. |
| Ctrl+C | Interrupt the foreground command. |
| Ctrl+D on an empty prompt | Send end-of-input; many shells exit. |
| `exit`, then Enter | Exit the shell and close Yildun's session. |

These are shell controls, not a Yildun shortcut map. If the outer terminal intercepts a key combination, Yildun does not receive it.

Pasting uses the input sent by your outer terminal. There is no separate clipboard control in the console. Resize the outer terminal to resize the session; `--columns` and `--rows` set its initial size, but interactive rendering then follows the real terminal dimensions.

## Read output

The console renders text from the current screen. The underlying session parses terminal control sequences and keeps bounded scrollback, but the console does not reproduce each cell's color or style, display an application cursor, or offer a scrollback browser.

When the child process ends, Yildun restores terminal input mode and clears its console display. Use [headless mode](headless.md) to keep a plain-text screen snapshot in a file.

## Tabs, panes, search, and links

The Ruby library includes tab management, pane state, search, selection, links, and session-state helpers. The executable's console does not provide a tab bar, pane layout, search field, clickable links, or session restoration.

The default settings contain entries such as `cmd+t`, `cmd+d`, and `cmd+f`, but the console does not dispatch those keymap actions. Changing them does not create working console shortcuts. Use the shell's own controls for interactive work; use the Ruby APIs when embedding Yildun in another interface.

See [Configuration](configuration.md) to choose the shell and environment that the console starts with.
