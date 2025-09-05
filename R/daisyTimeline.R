#' Daisy Timeline
#'
#' Create a Daisy Timeline
#'
#' @param data A data frame
#' @param date Column or expression for dates (supports expressions like lubridate::year(date_col))
#' @param title Column or expression for titles/content (can include HTML via shiny::HTML or htmltools::HTML)
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
#' # Using HTML links
#' events_df2 <- data.frame(
#'   year = c("2022", "2023", "2024"),
#'   name = c("Project Start", "Beta Release", "Launch"),
#'   url = c("https://project.com/start", "https://project.com/beta", "https://project.com/launch")
#' )
#' daisyTimeline(events_df2, 
#'               date = year, 
#'               title = shiny::HTML(paste0('<a href="', url, '">', name, '</a>')))
#'
#' # Or using htmltools
#' library(htmltools)
#' daisyTimeline(events_df2,
#'               date = year,
#'               title = htmltools::HTML(paste0('<a href="', url, '">', name, '</a>')))
#'
#' # Complex expressions with links
#' sales_data <- data.frame(
#'   quarter = c("Q1", "Q2", "Q3", "Q4"),
#'   revenue = c(100, 150, 200, 250),
#'   target = c(120, 140, 180, 240),
#'   report_url = c("q1.html", "q2.html", "q3.html", "q4.html")
#' )
#' daisyTimeline(sales_data,
#'               date = paste0("2024 ", quarter),
#'               title = shiny::HTML(ifelse(revenue >= target, 
#'                             paste0('<a href="', report_url, '">✅ $', revenue, 'k (met target)</a>'),
#'                             paste0('<a href="', report_url, '">❌ $', revenue, 'k (missed target)</a>'))))
#'
#' @import htmlwidgets
#' @importFrom purrr list_transpose
#' @importFrom purrr map_if
#' @importFrom rlang enquo
#' @importFrom rlang eval_tidy
#' @importFrom htmltools HTML
#'
#' @export
daisyTimeline <- function(data, date = NULL, title = NULL, width = NULL, height = NULL, elementId = NULL, ...) {
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
    
    # Check if title expression is wrapped in HTML function
    title_expr_text <- rlang::quo_text(title_expr)
    is_html_wrapped <- grepl("^(shiny::HTML|htmltools::HTML|HTML)\\s*\\(", title_expr_text)
    
    if (is_html_wrapped) {
      # Extract the inner expression from HTML wrapper
      inner_text <- sub("^(shiny::HTML|htmltools::HTML|HTML)\\s*\\(", "", title_expr_text)
      inner_text <- sub("\\)$", "", inner_text)
      inner_expr <- rlang::parse_expr(inner_text)
      
      # Evaluate the inner expression first
      title_result <- eval_tidy(inner_expr, data)
      
      # Apply HTML wrapper element-wise
      if (grepl("^shiny::HTML", title_expr_text)) {
        title_result <- lapply(title_result, function(x) shiny::HTML(x))
      } else if (grepl("^htmltools::HTML", title_expr_text)) {
        title_result <- lapply(title_result, function(x) htmltools::HTML(x))
      } else {
        title_result <- lapply(title_result, function(x) htmltools::HTML(x))
      }
    } else {
      # Normal evaluation for non-HTML expressions
      title_result <- eval_tidy(title_expr, data)
    }
    
    # Evaluate expressions in the context of the data frame
    # Handle the case where title_result is a list (from HTML processing)
    if (is.list(title_result) && !is.data.frame(title_result)) {
      processed_data <- data.frame(
        date = eval_tidy(date_expr, data),
        content = I(title_result),  # Use I() to protect the list structure
        stringsAsFactors = FALSE
      )
    } else {
      processed_data <- data.frame(
        date = eval_tidy(date_expr, data),
        content = title_result,
        stringsAsFactors = FALSE
      )
    }
  }
  
  # Helper function to convert HTML objects to character
  convert_html_content <- function(x) {
    if (inherits(x, "html")) {
      # Handle shiny::HTML or htmltools::HTML objects
      as.character(x)
    } else if (is.factor(x)) {
      as.character(x)
    } else {
      x
    }
  }
  
  # Flag whether content contains HTML (check before conversion)
  has_html <- any(sapply(processed_data$content, function(x) inherits(x, "html")))
  
  # Convert HTML objects to character strings
  if (has_html) {
    # Handle the case where content is a protected list
    if (is.list(processed_data$content) && inherits(processed_data$content, "AsIs")) {
      processed_data$content <- lapply(processed_data$content, convert_html_content)
      # Remove the AsIs protection
      class(processed_data$content) <- "list"
    } else {
      processed_data$content <- sapply(processed_data$content, convert_html_content)
    }
  }
  
  # Convert to events list and transpose
  events_list <- processed_data |>
    purrr::map_if(is.factor, as.character) |>
    list_transpose(simplify = FALSE)
  
  htmlwidgets::createWidget(
    name = "daisyTimeline",
    x = list(
      events = events_list,
      hasHTML = has_html
    ),
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
