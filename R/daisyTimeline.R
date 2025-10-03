#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param data A data frame
#' @param date Column or expression for dates (supports expressions like lubridate::year(date_col))
#' @param title Column or expression for titles/content
#' @param width Width of the widget
#' @param height Height of the widget
#' @param elementId HTML element ID
#'
#' @examples
#' # Basic usage with column names
#' events_df <- data.frame(
#'   year = c("2022", "2023", "2024"),
#'   description = c("Planning", "Development", "Launch")
#' )
#' daisyTimeline(events_df, date = year, title = description)
#'
#' # Using expressions for date formatting
#' events_df2 <- data.frame(
#'   event_year = c(2022, 2023, 2024),
#'   event_name = c("Start", "Progress", "Finish")
#' )
#' daisyTimeline(events_df2, 
#'               date = as.character(event_year), 
#'               title = paste0("Phase: ", event_name))
#'
#' # With lubridate expressions (if available)
#' \dontrun{
#' library(lubridate)
#' events_df3 <- data.frame(
#'   full_date = as.Date(c("2022-01-15", "2023-06-20", "2024-12-01")),
#'   milestone = c("Kickoff", "Beta", "Release")
#' )
#' daisyTimeline(events_df3,
#'               date = year(full_date),
#'               title = paste0(milestone, " (", month(full_date, label = TRUE), ")"))
#' }
#'
#' # Complex expressions
#' sales_data <- data.frame(
#'   quarter = c("Q1", "Q2", "Q3", "Q4"),
#'   revenue = c(100, 150, 200, 250),
#'   target = c(120, 140, 180, 240)
#' )
#' daisyTimeline(sales_data,
#'               date = paste0("2024 ", quarter),
#'               title = ifelse(revenue >= target, 
#'                             paste0("✅ $", revenue, "k (met target)"),
#'                             paste0("❌ $", revenue, "k (missed target)")))
#'
#' @import htmlwidgets
#' @importFrom purrr list_transpose
#' @importFrom purrr map_if
#' @importFrom rlang enquo
#' @importFrom rlang eval_tidy
#'
#' @export
daisyTimeline <- function(data, date = NULL, title = NULL, width = NULL, height = NULL, elementId = NULL) {
  # Validate input is a data frame
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame")
  }
  
  # Handle backwards compatibility - if no date/title provided, use first two columns
  if (missing(date) && missing(title)) {
    if (ncol(data) < 2) {
      stop("Data frame must have at least 2 columns when date and title are not specified")
    }
    processed_data <- data.frame(
      date = data[[1]],
      content = data[[2]]
    )
  } else {
    # Capture expressions using tidy eval
    date_expr <- enquo(date)
    title_expr <- enquo(title)
    
    # Evaluate expressions in the context of the data frame
    processed_data <- data.frame(
      date = eval_tidy(date_expr, data),
      content = eval_tidy(title_expr, data)
    )
  }
  
  # Convert factor columns to character and transpose
  events_list <- processed_data |>
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
renderDaisyTimeline <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, daisyTimelineOutput, env, quoted = TRUE)
}
