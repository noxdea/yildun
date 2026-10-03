---
layout: guide
title: Headless sessions
description: Capture terminal screens, send scripted input, and compare output with a fixture.
---

Headless mode starts a real terminal session, pumps its output, prints the visible screen as plain text, and closes the session. It does not need TTY input or output.

## Run a command

```sh
yildun --headless --command 'printf "hello\n"' \
  --columns 20 --rows 3 --timeout 1
```

The screen contains `hello` followed by blank rows. Redirect it to preserve the snapshot:

```sh
yildun --headless --command 'printf "hello\n"' \
  --columns 20 --rows 3 --timeout 1 > screen.txt
```

This captures visible terminal text, not an entire output log. Earlier lines can scroll off-screen; terminal controls can overwrite or clear existing output. Color escape sequences are parsed rather than printed.

## Compare with a fixture

Create a small expected screen:

```sh
printf 'hello\n' > expected.txt
yildun --headless --command 'printf "hello\n"' \
  --columns 20 --rows 3 --timeout 1 --expect expected.txt
```

Yildun reads `expected.txt` and compares it with the final screen after applying Ruby's `strip` to both strings. Leading and trailing whitespace around the whole screen is ignored; interior line breaks, spaces, and text must match. A mismatch exits with an error such as `headless output did not match expected.txt`.

Keep fixture dimensions fixed. Avoid timestamps, prompts that depend on your directory, and output that changes with the environment. A command can exit quickly enough that pending output is not captured; for timing-sensitive fixtures, keep it alive briefly after writing, for example `--command 'printf "hello\n"; sleep 0.1'`.

## Send scripted input

`--script` sends a file's contents to the session once, before headless output pumping or interactive console input begins. It does not execute the file as a shell-script pathname.

Create the input file:

```sh
printf 'printf "ready\\n"\nexit\n' > commands.txt
yildun --headless --command 'sh -s' --script commands.txt \
  --columns 80 --rows 8 --timeout 1
```

The shell receives a command that prints `ready`, followed by `exit`. Because the session uses a terminal, input echo and shell prompts may also appear in the screen. Include line endings for commands that need Enter, and provide `exit` when the shell should finish. For a predictable output fixture, prefer the direct `--command` example above.

`--script` also works with the interactive console: it sends initial input, then you can continue typing in the TTY.

## Command-line options

| Option | Default | Purpose |
| --- | --- | --- |
| `--headless` | Off | Print the final screen and close the session. |
| `--command COMMAND` | Default profile | Launch this command through a temporary profile. |
| `--script PATH` | None | Send the file's raw contents as terminal input. |
| `--expect PATH` | None | Compare the screen with a file; used only in headless mode. |
| `--columns N` | `80` | Set the screen width to a positive integer. |
| `--rows N` | `24` | Set the screen height to a positive integer. |
| `--timeout SECONDS` | `0.2` | Set the headless output-pumping duration in seconds. |
| `--version` | — | Print Yildun's version and exit. |

Run `yildun --help` for the executable's option list.

## Timing and exit behavior

Use a positive timeout long enough for the command to produce its output. The headless loop stops when the time limit is reached or the child is no longer alive. It does not guarantee that the command has finished when the snapshot is taken, and closing the session ends a child that is still running.

The executable does not propagate the child command's exit status. Without a failing `--expect` comparison or another Yildun error, the executable can succeed even when the command fails. Use a fixture to assert terminal output; use your test runner's process execution facilities when you need to assert a command's exit status.

Settings still load in headless mode. `--command` replaces profile-specific launch settings, but a malformed settings file can prevent startup. See [Configuration](configuration.md).
