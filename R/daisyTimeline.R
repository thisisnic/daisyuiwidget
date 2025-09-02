#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param data A data frame
#' @param date Column containing date information (can be a formula)
#' @param title Column containing event labels (can be a formula)
#' @param event Column containing event labels (deprecated, use title)
#' @param width Width of the widget
#' @param height Height of the widget
#' @param elementId HTML element ID
#'
#' @examples
#' # Create sample data
#' events_data <- data.frame(
#'   release_date = as.Date(c("2022-01-01", "2023-01-01")),
#'   package_name = c("dplyr", "ggplot2"),
#'   event = c("Major release", "Bug fixes")
#' )
#'
#' # Create timeline with formula-style column references
#' daisyTimeline(events_data,
#'               date = ~format(as.Date(release_date), "%Y"),
#'               title = ~event)
#'
#' # Using direct column names (backward compatibility)
#' events_simple <- data.frame(
#'   date = c("2022", "2023"),
#'   content = c("Release 1", "Release 2")
#' )
#' daisyTimeline(events_simple, date = date, title = content)
#'
#' @import htmlwidgets
#' @importFrom purrr list_transpose
#' @importFrom purrr map_if
#'
#' @export
daisyTimeline <- function(data, date, title = NULL, event = NULL, width = NULL, height = NULL, elementId = NULL) {
  # Validate input is a data frame
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame")
  }
  
  # Handle backward compatibility - use title if provided, otherwise event
  if (!missing(title)) {
    event_param <- title
  } else if (!missing(event)) {
    event_param <- event
  } else {
    stop("Either 'title' or 'event' parameter must be provided")
  }
  
  # Extract date column
  if (inherits(date, "formula")) {
    date_values <- eval(date[[2]], envir = data)
  } else {
    date_values <- data[[deparse(substitute(date))]]
  }
  
  # Extract event/title column
  if (inherits(event_param, "formula")) {
    content_values <- eval(event_param[[2]], envir = data)
  } else {
    content_values <- data[[deparse(substitute(event_param))]]
  }
  
  # Create processed data frame
  processed_data <- data.frame(
    date = date_values,
    content = content_values,
    stringsAsFactors = FALSE
  )
  
  # Convert factor columns to character and transpose
  events_list <- lapply(seq_len(nrow(processed_data)), function(i) {
    row_data <- processed_data[i, ]
    lapply(row_data, function(x) if (is.factor(x)) as.character(x) else x)
  })
  
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
