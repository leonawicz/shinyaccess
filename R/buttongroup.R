#' Button group input
#'
#' A Shiny button group input.
#'
#' The button group is a wrapper around \code{sa_radio} when
#' \code{multiple = FALSE} and \code{sa_checkboxgroup} when
#' \code{multiple = TRUE}.
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param choices List of values to show buttons for. If elements of the
#' list are named then that name rather than the value is displayed to the user.
#' If this argument is provided, then \code{choiceNames} and \code{choiceValues}
#' must not be provided, and vice-versa. The values should be strings;
#' other types (such as logicals and numbers) will be coerced to strings.
#' @param selected The radio value that should be initially selected; or
#' checkbox group values, if any.
#' @param multiple logical, allow multiple selections.
#' @param color character, hex or R color name.
#' @param width not in use
#' @param choiceNames,choiceValues See \code{shiny::checkboxgroup}.
#' Vector of names and values, must have same length.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return A list of HTML elements that can be added to a UI definition.
#' @export
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
#'       actionButton("btn1", "Reset single button group to first"),
#'       sa_buttongroup(
#'         "bg1", "Single variable to show:",
#'         c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear", "A" = "a", "B" = "b"),
#'         selected = "am", color = "dodgerblue"),
#'       tableOutput("data1")
#'     ),
#'     column(3,
#'     actionButton("btn2", "Reset multiple button group to none"),
#'       sa_buttongroup(
#'         "bg2", "Multiple variables to show:",
#'         selected = c("cyl", "am"), multiple = TRUE, color = "firebrick",
#'         choiceNames = c("Cylinders", "Transmission", "Gears"),
#'         choiceValues = c("cyl", "am", "gear")),
#'       tableOutput("data2")
#'     )
#'   )
#' )
#' }
#'
#' server <- function(input, output, session) {
#'   output$data1 <- renderTable({
#'     mtcars[, c("mpg", input$bg1), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   output$data2 <- renderTable({
#'     mtcars[, c("mpg", input$bg2), drop = FALSE]
#'   }, rownames = TRUE)
#'
#'   observeEvent(input$btn1, {
#'     update_sa_buttongroup(session, "bg1", selected = "cyl")
#'   })
#'   observeEvent(input$btn2, {
#'     update_sa_buttongroup(session, "bg2", selected = character(0))
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_buttongroup <- function(inputId, label, choices = NULL, selected = NULL,
                           multiple = FALSE, color = "#555555",
                           width = NULL, choiceNames = NULL,
                           choiceValues = NULL){
  if(multiple){
    x <- sa_checkboxgroup(inputId, label, choices, selected, color, ncol = 1,
                          inline = TRUE, width, choiceNames, choiceValues)
  } else {
    x <- sa_radio(inputId, label, choices, selected, inline = TRUE, width,
                  choiceNames, choiceValues)
  }
  tagList(
    # attach styles like background color,
    shiny::div(x, class = "sa-buttongroup")
  )
}

#' @rdname sa_buttongroup
#' @export
update_sa_buttongroup <- function(session, inputId, label = NULL,
                                    choices = NULL, selected = NULL){
  message <- dropNulls(list(label = label, choices = choices, inline = TRUE,
                            value = selected))
  session$sendInputMessage(inputId, message)
}
