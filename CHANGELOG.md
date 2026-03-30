# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- Defaulted slide output to self-contained HTML.
- Switched the default math renderer to KaTeX so offline
  presentations remain fully portable in a single file.
- Documented how to override the self-contained and math
  defaults per deck.

## [1.0.0] - 2026-03-30

- Initial standalone Quarto extension release.
- Added the Caltech revealjs format, title slide partial, logo injection,
  layout classes, and callout styles.
- Added explicit R helper sourcing via `caltech-setup.R` for
  `theme_caltech()` and `orange_scheme`.
- Added `example.qmd`, `template.qmd`, and a no-R smoke-test deck.
- Added a smoke-test script for local and CI render checks.
