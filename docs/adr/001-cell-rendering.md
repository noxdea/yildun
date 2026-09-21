# 001: Cell rendering stays outside the element tree

## Status

Accepted

## Decision

Yildun keeps terminal cells in Tarazed's grid and exposes them to a dedicated
view adapter. It does not turn every cell into a general UI element.

## Consequences

The terminal can apply damage updates without rebuilding an element tree. A
future Zaniah window may consume the same grid while the headless executable
remains usable without a graphics backend.
