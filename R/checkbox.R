#' Checkbox input
#'
#' A Shiny checkbox input.
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param value logical, default toggle state.
#' @param color character, hex or R color name.
#' @param width The width of the input, e.g. '400px', or '100%'; see
#' \code{shiny::validateCssUnit}.
#' @param session The session object passed to function given to shinyServer.
#'
#' @return HTML element that can be added to a UI definition.
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
#'       actionButton("btn1", "Set to TRUE"),
#'       actionButton("btn2", "Change label"),
#'       sa_checkbox("cb1", "Show text A", FALSE, "firebrick", 200),
#'       sa_checkbox("cb2", "Show text B", TRUE)
#'     ),
#'     column(9, textOutput("txt1"), textOutput("txt2"))
#'   )
#' )
#' }
#'
#' server <- function(input, output, session) {
#'   output$txt1 <- renderText(paste("Checkbox 1 input is set to", input$cb1))
#'   output$txt2 <- renderText(paste("Checkbox 2 input is set to", input$cb2))
#'   observeEvent(input$btn1, {
#'     update_sa_checkbox(session, "cb1", value = TRUE)
#'   })
#'   observeEvent(input$btn2, {
#'     update_sa_checkbox(session, "cb1", label = "Show text A 2")
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_checkbox <- function(inputId, label, value = FALSE, color = "#555555",
                        width = NULL){
  id <- paste0("sa-input-checkbox-", inputId)
  x <- div(id = inputId, class = "sa-input-checkbox",
    tagList(tags$input(id = id, type = "checkbox"), tags$label(`for` = id, label))
  )
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-sa-checkbox.js", package = "shinyaccess")
    ))),
    tags$style(paste0(
      "#", inputId, " input:checked + label:before {background-color: ", colorname_to_hex(color), "; }"
    )),
    x
  )
}

#' @rdname sa_checkbox
#' @export
update_sa_checkbox <- function(session, inputId, label = NULL, value = NULL){
  message <- dropNulls(list(label = label, value = value))
  session$sendInputMessage(inputId, message)
}
