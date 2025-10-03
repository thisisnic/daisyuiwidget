#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param data A data frame
#' @param date Column containing date information (can be a formula)
#' @param title Column containing event labels (can be a formula)
#' @param width Width of the widget
#' @param height Height of the widget
#' @param elementId HTML element ID
#'
#' @examples
#' # Create sample data
#' events_data <- data.frame(
#'   release_date = c("2022-01-01", "2023-01-01"),
#'   package_name = c("dplyr", "ggplot2"),
#'   event = c("Major release", "Bug fixes")
#' )
#' 
#'# Using simple column names 
#' daisyTimeline(events_data, date = ~release_date, title = ~package_name)
#'
#' # Create timeline with formula-style column references
#' daisyTimeline(events_data,
#'               date = ~format(as.Date(release_date), "%Y"),
#'               title = ~paste(package_name, "-", event))
#'
#' @import htmlwidgets
#'
#' @export
daisyTimeline <- function(data, date, title, width = NULL, height = NULL, elementId = NULL) {
  # Validate input is a data frame
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame")
  }
  
  # Extract date column
  if (inherits(date, "formula")) {
    date_values <- eval(date[[2]], envir = data)
  } else {
    date_values <- data[[deparse(substitute(date))]]
  }
  
  # Extract title column
  if (inherits(title, "formula")) {
    content_values <- eval(title[[2]], envir = data)
  } else {
    content_values <- data[[deparse(substitute(title))]]
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
