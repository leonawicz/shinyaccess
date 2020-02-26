#' Toggle input
#'
#' A binary toggle Shiny input.
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
#' @param label_color color of label text.
#' @param text_color color of left and right value label text.
#' @param width The width of the input, e.g. '400px', or '100%'; see
#' \code{shiny::validateCssUnit}.
#'
#' @return HTML element that can be added to a UI definition.
#' @export
#'
#' @examples
#' if (interactive()) {
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
#'         "toggle1", "Show text 1", FALSE, "On", "Off",
#'         "navyblue", "#000000", "white", "200px"
#'       )
#'     ),
#'     column(9, textOutput("txt"))
#'   )
#' )
#' }
#'
#' server <- function(input, output, session) {
#'   output$txt <- renderText(paste("Toggle input is set to", input$toggle1))
#'   observeEvent(input$btn1, {
#'     update_sa_toggle(session, "toggle1", value = TRUE)
#'   })
#'   observeEvent(input$btn2, {
#'     update_sa_toggle(session, "toggle1", label = "Show text 2",
#'                      true = "Yes", false = "no")
#'   })
#' }
#'
#' shinyApp(ui, server, enableBookmarking = "url")
#'
#' }
sa_toggle <- function(inputId, label, value = FALSE, true = "Yes", false = "No",
                      color = "blue", label_color = "black",
                      text_color = label_color, width = NULL){
  x <- paste0(
    '<div id="', inputId, '" class="sa-input-toggle">',
    '\n  <label>', label, '</label>',
    '\n  <button role="switch" aria-labelledby="', inputId,
    '" aria-checked="', tolower(value), '" class="sa-togglebtn">',
    '\n    <span>', true, '</span>\n    <span>', false, '</span>',
    '\n  </button>\n</div>'
  )
  tagList(
    singleton(tags$head(includeScript(
      system.file("resources/input-binding-sa-toggle.js", package = "shinyaccess")
    ))),
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
