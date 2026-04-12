# Caltech Revealjs

A [Quarto](https://quarto.org/) format extension for
[revealjs](https://revealjs.com/) presentations using
Caltech's visual identity: orange (#FF6A14) headings on a
cream (#FFF0E7) background, with Cabin, Noto Sans, and
Source Code Pro fonts.

## Installation

```bash
quarto add jnkatz/caltech-revealjs
```

This installs the extension into `_extensions/caltech/` in
your project directory.

## Usage

Set the format in your `.qmd` YAML header:

```yaml
---
title: "Presentation Title"
subtitle: "Subtitle"
author: "Author Name"
institute: "Caltech"
date: today
format: caltech-revealjs
---
```

That is enough for Markdown-only decks. The extension
provides the visual theme, layout classes, and the Caltech
logo (bottom-left on every slide).

By default, the extension renders portable self-contained
HTML so a single output file can be copied to another machine
or user account without needing separate asset folders. That
includes CSS, JavaScript, images, fonts, and math rendering.

If your deck uses R and calls `theme_caltech()`,
`orange_scheme`, or `caltech_image_carousel()`, source the
helper file once in a hidden setup chunk. The helper is not
injected automatically.

## Starting A New Deck

For a Markdown-only deck, this is enough:

```yaml
---
title: "Presentation Title"
subtitle: "Subtitle"
author: "Author Name"
institute: "Caltech"
date: today
format: caltech-revealjs
---
```

For a deck that uses R and needs `theme_caltech()`,
`orange_scheme`, or `caltech_image_carousel()`, add one
hidden setup chunk immediately after the YAML:

````qmd
---
title: "Presentation Title"
subtitle: "Subtitle"
author: "Author Name"
institute: "Caltech"
date: today
format: caltech-revealjs
---

```{r}
#| include: false
#| cache: false
source("_extensions/caltech/caltech-setup.R")
```
````

You can start from `template.qmd` in this repository.

## Changing The Default

The extension defaults to self-contained output:

```yaml
format:
  caltech-revealjs:
    embed-resources: true
    html-math-method: katex
    self-contained-math: true
```

If you want smaller, non-embedded output for local iteration,
override those settings in a deck:

```yaml
format:
  caltech-revealjs:
    embed-resources: false
    html-math-method: mathjax
    self-contained-math: false
```

If you prefer MathJax over KaTeX, you can also override just
the math renderer while keeping self-contained output for the
rest of the deck:

```yaml
format:
  caltech-revealjs:
    html-math-method: mathjax
```

## What's Included

### Visual theme

- **Fonts**: Cabin (headings), Noto Sans (body),
  Source Code Pro (code) — loaded from Google Fonts
- **Colors**: orange headings, cream background, orange
  inline code, alternating-row tables
- **Slides**: 1280x720 (16:9), GitHub syntax highlighting,
  slide numbers (current/total), self-contained HTML output
  with KaTeX-rendered math by default
- **Fragments**: top-level bullet lists display incrementally
  by default; nested lists keep their authored behavior. On
  `.pull-left` / `.pull-right` slides with a figure in the
  right column, the first left-column bullet is visible when
  the slide opens.

### Layout classes

| Class | Effect |
|---|---|
| `.pull-left` / `.pull-right` | Two columns (47% each) |
| `.pull-left-3` / `.pull-middle-3` / `.pull-right-3` | Three columns (30% each) |
| `.left-column` / `.right-column` | Sidebar (20%) + main (75%) |
| `.left-code` / `.right-plot` | Code (38%) + plot (56%) |
| `.center` | Center-align content |
| `.footnote` | Absolute-positioned footnote |

### Callout classes

| Class | Effect |
|---|---|
| `.box-2` | Compact inline callout for short prompts or annotations |
| `.box-4` | Larger callout block for datasets or explanatory notes |

### Slide classes

| Class | Effect |
|---|---|
| `{.inverse}` | Orange background, cream text |
| `{.header_background}` | Orange banner behind heading |
| `{.hide_logo}` | Hide the Caltech logo |

Speaker notes use Quarto's built-in `::: {.notes}` blocks.

### R integration

For slide decks that use R code and need the Caltech helpers,
source the helper file once in a hidden setup chunk:

```r
#| include: false
#| cache: false
source("_extensions/caltech/caltech-setup.R")
```

This provides these R objects:

- **`theme_caltech()`** — a ggplot2 theme matching the
  slide background and fonts. Parameters:
  - `background_color` (default `"#FFF0E7"`)
  - `text_font_size` (default `12`)
- **`orange_scheme`** — a 6-color orange palette for
  `bayesplot::color_scheme_set()`
- **`caltech_image_carousel()`** — an as-is HTML image
  carousel for revealjs slides. It preserves the order of the
  `images` vector unless `sort_key` is supplied, starts on the
  first image, resets on slide entry, and has no `slickR` or
  htmlwidget dependency.

Example:

```r
#| echo: false
#| results: asis
images <- list.files("book-images", pattern = "\\.jpe?g$", full.names = TRUE)
years <- as.integer(gsub("\\D", "", basename(images)))
caltech_image_carousel(
  images,
  id = "book-carousel",
  captions = years,
  alt = paste("Book cover from", years),
  sort_key = years
)
```

### Default knitr options

The extension sets sensible defaults for R chunks:

| Option | Default |
|---|---|
| `echo` | `true` |
| `cache` | `true` |
| `fig.width` | `6` |
| `fig.height` | `3.708` |
| `fig.retina` | `3` |
| `fig.align` | `center` |
| `warning` | `false` |
| `message` | `false` |

Override any of these per-chunk or in your YAML header.

## Smoke Tests

This repository includes three lightweight render checks:

- `example.qmd` exercises the R helper workflow and the
  main layout/callout classes.
- `template.qmd` verifies the starter deck renders cleanly.
- `no-r-smoke.qmd` verifies the extension works for a
  deck with no R setup chunk.

Run them all with:

```bash
bash scripts/smoke-test.sh
```

Or run them individually with `quarto render`.

The same smoke tests run in GitHub Actions on pushes, pull
requests, and manual workflow dispatches.

## Example

See `example.qmd` for a comprehensive demo of all
features. Render it with:

```bash
quarto render example.qmd
```

## Development Workflow

Treat this repository as the canonical source of truth for
the theme. If another project vendors `_extensions/caltech`,
update it from here rather than editing both copies.

Before syncing into another project, run the smoke tests:

```bash
bash scripts/smoke-test.sh
```

If you want a single quick check, render the standalone example:

```bash
quarto render example.qmd
```

Sync the extension into a consuming project:

```bash
rsync -a --delete _extensions/caltech/ /path/to/project/_extensions/caltech/
```

`example.qmd` is a demo and render smoke test. The reusable
source lives in `_extensions/caltech/`.

## Releases

This repository keeps a lightweight release process:

- update `CHANGELOG.md` when the extension behavior changes
- keep `_extensions/caltech/_extension.yml` versioned
- tag stable points in `main` with release versions such as
  `v1.0.0`

## Requirements

- Quarto >= 1.3.0
- R with ggplot2 (for `theme_caltech()`)

## License

MIT
