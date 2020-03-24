#' Toggle input
#'
#' A Shiny binary toggle input.
#'
#' This input returns \code{TRUE} or \code{FALSE} similar to
#' \code{shiny::checkboxInput}.
#'
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param value logical, default toggle state.
#' @param true character, left label for \code{TRUE} state.
#' @param false character, right label for \code{FALSE} state.
#' @param color active state color.
#' @param text_color color of left and right value label text.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100%'};
#' see \code{shiny::validateCssUnit}.
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
#'       sa_toggle(
#'         "toggle1", "Show text A", FALSE, "On", "Off",
#'         "firebrick", "white", 200
#'       ),
#'       sa_toggle(
#'         "toggle2", "Show text B", TRUE, "On", "Off",
#'         "yellowgreen", "black"
#'       )
#'     ),
#'     column(9, textOutput("txt1"), textOutput("txt2"))
#'   )
#' )
#' }
#'
#' server <- function(input, output, session) {
#'   output$txt1 <- renderText(paste("Toggle input 1 is set to", input$toggle1))
#'   output$txt2 <- renderText(paste("Toggle input 2 is set to", input$toggle2))
#'   observeEvent(input$btn1, {
#'     update_sa_toggle(session, "toggle1", value = TRUE)
#'   })
#'   observeEvent(input$btn2, {
#'     update_sa_toggle(session, "toggle1", label = "Show text A 2",
#'                      true = "Yes", false = "No")
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_toggle <- function(inputId, label, value = FALSE, true = "Yes", false = "No",
                      color = "blue", text_color = "black", width = NULL){
  value <- shiny::restoreInput(id = inputId, default = value)
  x <- paste0(
    '<div id="', inputId, '" class="sa-input-toggle">',
    '\n  <label>', label, '</label>',
    '\n  <button role="switch" aria-labelledby="', inputId,
    '" aria-checked="', tolower(value), '" class="sa-togglebtn"',
    if(!is.null(width))
      paste0('style="width:', shiny::validateCssUnit(width), ';"'),
    '>', '\n    <span>', true, '</span>\n    <span>', false, '</span>',
    '\n  </button>\n</div>'
  )
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-sa-toggle.js", package = "shinyaccess")
    ))),
    tags$style(paste0(
      "#", inputId, " button.sa-togglebtn[role=switch][aria-checked=true]",
      " :first-child, #", inputId,
      " button.sa-togglebtn[role=switch][aria-checked=false]",
      " :last-child { background-color: ", colorname_to_hex(color),
      "; color: ", colorname_to_hex(text_color), "; }"
    )),
    HTML(x)
  )
}

#' @rdname sa_toggle
#' @export
update_sa_toggle <- function(session, inputId, label = NULL, value = NULL,
                             true = NULL, false = NULL){
  message <- dropNulls(list(label = label, value = value, value_labels = c(true, false)))
  session$sendInputMessage(inputId, message)
}
