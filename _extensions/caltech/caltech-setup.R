# Caltech Revealjs Extension — R setup
# Source this from an R setup chunk when using theme_caltech(),
# orange_scheme, or other Caltech slide helpers.

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

caltech_current_file <- function(default = "caltech-setup.R") {
  frames <- sys.frames()
  for (frame in rev(frames)) {
    file <- frame$ofile
    if (!is.null(file) && file.exists(file)) {
      return(normalizePath(file))
    }
  }

  normalizePath(default, mustWork = FALSE)
}

caltech_setup_path <- caltech_current_file()
source(file.path(dirname(caltech_setup_path), "_common.R"))

caltech_font_or <- function(preferred, fallback) {
  if (!requireNamespace("systemfonts", quietly = TRUE)) {
    return(preferred)
  }

  available <- tryCatch(
    unique(systemfonts::system_fonts()$family),
    error = function(e) character()
  )

  if (preferred %in% available) preferred else fallback
}

# Caltech ggplot2 theme — matches slide background and fonts
theme_caltech <- function(
  background_color = "#FFF0E7",
  text_font_size = 12,
  ...
) {
  body_font <- caltech_font_or("Noto Sans", "sans")
  heading_font <- caltech_font_or("Cabin", body_font)

  ggplot2::theme_minimal(base_family = body_font, ...) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      panel.background = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      text = ggplot2::element_text(
        family = body_font,
        size = text_font_size
      ),
      plot.title = ggplot2::element_text(
        family = heading_font,
        color = "#FF6A14"
      )
    )
}

# Bayesplot orange color scheme
orange_scheme <- c(
  "#FF721C",
  "#FF7A24",
  "#FF802A",
  "#FF8933",
  "#FF933D",
  "#FF9B45"
)
