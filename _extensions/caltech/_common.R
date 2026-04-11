# Shared R helpers for the Caltech revealjs extension.

.caltech_carousel_state <- new.env(parent = emptyenv())
.caltech_carousel_state$counter <- 0L

caltech_html_escape <- function(x) {
  x <- as.character(x)
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("\"", "&quot;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

caltech_carousel_id <- function() {
  .caltech_carousel_state$counter <- .caltech_carousel_state$counter + 1L
  paste0("caltech-carousel-", .caltech_carousel_state$counter)
}

caltech_css_size <- function(x) {
  if (is.numeric(x)) {
    return(paste0(x, "px"))
  }

  as.character(x)
}

caltech_recycle_arg <- function(x, n, name) {
  if (is.null(x)) {
    return(rep(NA_character_, n))
  }

  if (length(x) == 1L && n != 1L) {
    return(rep(as.character(x), n))
  }

  if (length(x) != n) {
    stop("`", name, "` must have length 1 or the same length as `images`.", call. = FALSE)
  }

  as.character(x)
}

#' Create a revealjs-friendly image carousel.
#'
#' Returns an as-is HTML fragment for use in Quarto/knitr slide decks.
#' Image order is preserved unless `sort_key` is supplied.
caltech_image_carousel <- function(
  images,
  id = NULL,
  captions = NULL,
  alt = NULL,
  sort_key = NULL,
  interval = 1500,
  image_max_height = "420px",
  dots = TRUE,
  pause_on_hover = TRUE,
  reset_on_slide = TRUE
) {
  if (length(images) == 0L) {
    stop("`images` must contain at least one image path.", call. = FALSE)
  }

  images <- as.character(images)
  captions <- caltech_recycle_arg(captions, length(images), "captions")
  alt <- caltech_recycle_arg(alt, length(images), "alt")

  if (!is.null(sort_key)) {
    if (length(sort_key) != length(images)) {
      stop("`sort_key` must have the same length as `images`.", call. = FALSE)
    }
    ord <- order(sort_key, na.last = TRUE)
    images <- images[ord]
    captions <- captions[ord]
    alt <- alt[ord]
  }

  if (is.null(id)) {
    id <- caltech_carousel_id()
  }

  if (!grepl("^[A-Za-z][A-Za-z0-9_-]*$", id)) {
    stop("`id` must start with a letter and contain only letters, numbers, underscores, or hyphens.", call. = FALSE)
  }

  if (!is.numeric(interval) || length(interval) != 1L || is.na(interval) || interval < 0) {
    stop("`interval` must be a non-negative number.", call. = FALSE)
  }

  image_max_height <- caltech_css_size(image_max_height)
  ifelse_na <- function(x, replacement) ifelse(is.na(x), replacement, x)

  alt <- ifelse_na(alt, basename(images))
  captions_html <- ifelse(
    is.na(captions),
    "",
    paste0("<figcaption>", caltech_html_escape(captions), "</figcaption>")
  )

  item_html <- paste(
    sprintf(
      paste0(
        '<figure class="caltech-carousel__item%s">',
        '<img src="%s" alt="%s" style="max-height: %s;">',
        "%s",
        "</figure>"
      ),
      ifelse(seq_along(images) == 1L, " is-active", ""),
      caltech_html_escape(images),
      caltech_html_escape(alt),
      caltech_html_escape(image_max_height),
      captions_html
    ),
    collapse = "\n"
  )

  dot_html <- ""
  if (isTRUE(dots) && length(images) > 1L) {
    dot_label <- ifelse_na(captions, basename(images))
    dot_html <- paste0(
      '<div class="caltech-carousel__dots" aria-label="Image carousel controls">',
      paste(
        sprintf(
          '<button class="caltech-carousel__dot%s" type="button" data-index="%s" aria-label="Show %s"></button>',
          ifelse(seq_along(images) == 1L, " is-active", ""),
          seq_along(images) - 1L,
          caltech_html_escape(dot_label)
        ),
        collapse = "\n"
      ),
      "</div>"
    )
  }

  data_attrs <- paste0(
    ' data-interval="', as.integer(interval), '"',
    ' data-pause-on-hover="', tolower(as.character(isTRUE(pause_on_hover))), '"',
    ' data-reset-on-slide="', tolower(as.character(isTRUE(reset_on_slide))), '"'
  )

  html <- paste0(
    '<div id="', caltech_html_escape(id), '" class="caltech-carousel"', data_attrs, ">",
    '<div class="caltech-carousel__stage">',
    item_html,
    dot_html,
    "</div></div>",
    '<script>
(function() {
  const root = document.getElementById("', caltech_html_escape(id), '");
  if (!root || root.dataset.ready === "true") return;
  root.dataset.ready = "true";

  const items = Array.from(root.querySelectorAll(".caltech-carousel__item"));
  const dots = Array.from(root.querySelectorAll(".caltech-carousel__dot"));
  const interval = Number(root.dataset.interval || 1500);
  const pauseOnHover = root.dataset.pauseOnHover === "true";
  const resetOnSlide = root.dataset.resetOnSlide === "true";
  let active = 0;
  let timer = null;

  function show(next) {
    if (!items.length) return;
    active = (next + items.length) % items.length;
    items.forEach((item, index) => item.classList.toggle("is-active", index === active));
    dots.forEach((dot, index) => dot.classList.toggle("is-active", index === active));
  }

  function stop() {
    if (timer) window.clearInterval(timer);
    timer = null;
  }

  function start(reset) {
    stop();
    if (reset) show(0);
    if (items.length > 1 && interval > 0) {
      timer = window.setInterval(() => show(active + 1), interval);
    }
  }

  function slideContainsCarousel(slide) {
    return slide && slide.contains(root);
  }

  dots.forEach((dot) => {
    dot.addEventListener("click", () => {
      stop();
      show(Number(dot.dataset.index));
      start(false);
    });
  });

  if (pauseOnHover) {
    root.addEventListener("mouseenter", stop);
    root.addEventListener("mouseleave", () => start(false));
  }

  document.addEventListener("slideenter", (event) => {
    if (slideContainsCarousel(event.target)) start(resetOnSlide);
  });

  document.addEventListener("slideleave", (event) => {
    if (slideContainsCarousel(event.target)) stop();
  });

  function wireReveal() {
    if (!window.Reveal || typeof window.Reveal.on !== "function") return;
    window.Reveal.on("slidechanged", (event) => {
      if (slideContainsCarousel(event.currentSlide)) start(resetOnSlide);
      else stop();
    });
    if (slideContainsCarousel(window.Reveal.getCurrentSlide())) start(resetOnSlide);
  }

  document.addEventListener("DOMContentLoaded", wireReveal);
  window.setTimeout(wireReveal, 500);
  show(0);
})();
</script>'
  )

  knitr::asis_output(html)
}
