#' Radio buttons input
#'
#' A Shiny radio buttons input.
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param choices List of values to select from (if elements of the list are
#' named then that name rather than the value is displayed to the user). If
#' this argument is provided, then \code{choiceNames} and \code{choiceValues}
#' must not be provided, and vice-versa. The values should be strings; other
#' types (such as logicals and numbers) will be coerced to strings.
#' @param selected The values that should be initially selected, if any.
#' @param inline if \code{TRUE}, \code{ncol} is ignored.
#' @param width not in use
#' @param choiceNames,choiceValues See \code{shiny::radioButtons}.
#' Vector of names and values, must have same length.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return A list of HTML elements that can be added to a UI definition.#' @export
#'
#' @examples
#' if (interactive()) {
#' library(shiny)
#'
#' ui <- function(request) {
#' fluidPage(
#'   use_access(),
#'   fluidRow(bookmarkButton()),
#'   fluidRow(
#'     column(3,
#'       actionButton("btn1", "Reset radio 1 to 'am'"),
#'       radioButtons(
#'         "radio1", "Shiny1 - Choose a variable:",
#'         list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'         width = "1000px"),
#'       tableOutput("data1")
#'     ),
#'     column(3,
#'       radioButtons(
#'         "radio2", "Shiny2 (inline) - Choose a variable:",
#'         list("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'         inline = TRUE),
#'       tableOutput("data2")
#'     ),
#'     column(3,
#'       actionButton("btn3", "Reset radio 3 to 'am'"),
#'       sa_radio(
#'         "radio3", "SA1 - Choose a variable:",
#'         c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear", "A" = "a", "B" = "b"),
#'         selected = "am"),
#'       tableOutput("data3")
#'     ),
#'     column(3,
#'     actionButton("btn4", "Reset radio 4 to 'gear'"),
#'       sa_radio(
#'         "radio4", "SA2 (inline) - Choose a variable:",
#'         selected = "cyl",
#'         choiceNames = c("Cylinders", "Transmission", "Gears"),
#'         choiceValues = c("cyl", "am", "gear"), inline = TRUE),
#'       tableOutput("data4")
#'     )
#'   )
#' )
#' }
#'
#' server <- function(input, output, session) {
#'   output$data1 <- renderTable({
#'     mtcars[, c("mpg", input$radio1), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   output$data2 <- renderTable({
#'     mtcars[, c("mpg", input$radio2), drop = FALSE]
#'   }, rownames = TRUE)
#'   output$data3 <- renderTable({
#'     mtcars[, c("mpg", input$radio3), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   output$data4 <- renderTable({
#'     mtcars[, c("mpg", input$radio4), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   observeEvent(input$btn1, {
#'     updateRadioButtons(session, "radio1", selected = "am")
#'   })
#'   observeEvent(input$btn3, {
#'     update_sa_radio(session, "radio3", selected = "am")
#'   })
#'   observeEvent(input$btn4, {
#'     update_sa_radio(session, "radio4", selected = "gear")
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_radio <- function(inputId, label, choices = NULL, selected = NULL,
                     inline = FALSE, width = NULL, choiceNames = NULL,
                     choiceValues = NULL){
  args <- normalizeChoicesArgs(choices, choiceNames, choiceValues)
  selected <- shiny::restoreInput(id = inputId, default = selected)
  selected <- if(is.null(selected)) args$choiceValues[[1]] else
    as.character(selected)
  if (length(selected) > 1)
    stop("The 'selected' argument must be of length 1")
  v <- unlist(args$choiceValues)
  vname <- unlist(args$choiceNames)
  x <- .sa_radio_opts(inputId, v, vname, selected, inline)
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-sa-radio.js", package = "shinyaccess")
    ))),
    HTML(
      paste0(
        '<fieldset id="', inputId, '" class="sa-input-radio">',
        '\n  <legend>', label, '</legend>', x, '\n</fieldset>'
      )
    )
  )
}

.sa_radio_opts <- function(inputId, v, vname, selected, inline){
  x <- sapply(seq_along(v), function(i){
    paste0(
      '\n    <li class="sa-option-item"',
      if(inline) ' style="display:inline-block;"', '>',
      '\n      <input type="radio" id="sa-radio-', inputId, '-', v[i],
      '" name="sa-radio-', inputId, '" value="', v[i], '"',
      if(v[i] %in% selected) ' checked', '>',
      '\n      <label for="sa-rdio-', inputId, '-', v[i], '">',
      vname[i], '</label>',
      '\n    </li>'
    )
  })
  x <- paste(x, collapse = "\n    ")
  paste0('\n  <ul class="sa-options-group">', x, '\n  </ul>', sep = "\n")
}

#' @rdname sa_radio
#' @export
update_sa_radio <- function(session, inputId, label = NULL, choices = NULL,
                            selected = NULL, inline = FALSE){
  message <- dropNulls(list(label = label, choices = choices, inline = inline,
                            value = selected))
  session$sendInputMessage(inputId, message)
}
