# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

- Defaulted slide output to self-contained HTML.
- Switched the default math renderer to KaTeX so offline
  presentations remain fully portable in a single file.
- Documented how to override the self-contained and math
  defaults per deck.
- Updated installation docs for public GitHub distribution.
- Moved the no-R smoke deck to the repository root.
- Updated smoke tests to install the extension into a clean
  temporary project before rendering, matching real usage.
- Replaced the custom title-slide partial with CSS-only
  styling of Quarto's default revealjs title slide to avoid
  cross-version template-partial resolution issues.
- Added `caltech_image_carousel()` for reusable revealjs image
  carousels without `slickR` or htmlwidget dependencies.
- Added default incremental display for top-level bullet lists
  while preserving nested-list behavior; on `.pull-left` /
  `.pull-right` slides with a right-column figure, the first
  left-column bullet is visible on slide entry.

## [1.0.0] - 2026-03-30

- Initial standalone Quarto extension release.
- Added the Caltech revealjs format, title slide partial, logo injection,
  layout classes, and callout styles.
- Added explicit R helper sourcing via `caltech-setup.R` for
  `theme_caltech()` and `orange_scheme`.
- Added `example.qmd`, `template.qmd`, and a no-R smoke-test deck.
- Added a smoke-test script for local and CI render checks.
