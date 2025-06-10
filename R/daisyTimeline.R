#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @import htmlwidgets
#'
#' @export
daisyTimeline <- function(events, width = NULL, height = NULL, elementId = NULL) {
  # events is a list of lists: each item has date, content, maybe side
  htmlwidgets::createWidget(
    name = "daisyTimeline",
    x = list(events = events),
    width = width,
    height = height,
    package = "daisyuiwidget1",
    elementId = elementId,
    dependencies = list(
      htmltools::htmlDependency(
        name = "tailwind-daisy",
        version = "1.0.0",
        src = system.file("htmlwidgets/lib", package = "daisyuiwidget1")#,
        #stylesheet = "tailwind-daisy.min.css"
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
daisyTimelineOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'daisyTimeline', width, height, package = 'daisyuiwidget1')
}

#' @rdname daisyTimeline-shiny
#' @export
renderDaisyTimeline <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, daisyTimelineOutput, env, quoted = TRUE)
}
