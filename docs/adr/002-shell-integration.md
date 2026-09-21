# 002: Shell integration is a first-class feature

## Status

Accepted

## Decision

Yildun exposes Tarazed command records, failed-command filtering, cwd
tracking, and previous/next command navigation instead of treating the PTY as
an opaque byte stream.

## Consequences

The application can attach command navigation and output actions to a future
window without duplicating OSC 133 parsing.
