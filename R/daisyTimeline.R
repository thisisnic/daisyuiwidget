#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param events A data frame with columns 'date' and 'content', and optionally 'side'
#' @param width Width of the widget
#' @param height Height of the widget
#' @param elementId HTML element ID
#'
#' @import htmlwidgets
#' @importFrom purrr list_transpose, map_if
#'
#' @export
daisyTimeline <- function(events, width = NULL, height = NULL, elementId = NULL) {
  # Validate input is a data frame
  if (!is.data.frame(events)) {
    stop("events must be a data frame")
  }

  # Check required columns
  if (!all(c("date", "content") %in% names(events))) {
    stop("Data frame must contain 'date' and 'content' columns")
  }

  # Convert factor columns to character and tranpose
  events_list <- events |>
    map_if(is.factor, as.character) |>
    list_transpose(simplify = FALSE)


  htmlwidgets::createWidget(
    name = "daisyTimeline",
    x = list(events = events_list),
    width = width,
    height = height,
    package = "daisyuiwidget",
    elementId = elementId,
    dependencies = list(
      htmltools::htmlDependency(
        name = "tailwind-daisy",
        version = "1.0.0",
        src = system.file("htmlwidgets/lib", package = "daisyuiwidget"),
      )
    )
  )
}




#' Shiny bindings for daisyTimeline
#'
#' Output and render functions for using daisyTimeline within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a daisyTimeline
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name daisyTimeline-shiny
#'
#' @export
daisyTimelineOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "daisyTimeline", width, height, package = "daisyuiwidget")
}

#' @rdname daisyTimeline-shiny
#' @export
renderDaisyTimeline <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, daisyTimelineOutput, env, quoted = TRUE)
}
