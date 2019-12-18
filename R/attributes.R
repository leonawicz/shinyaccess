#' Add HTML language attribute
#'
#' Add an HTML language attribute to an app.
#'
#' You can inspect the element in your browser to verify. The \code{<html>} tag
#' will include \code{lang="en"} by default.
#'
#' @param session Shiny session.
#' @param lang character, language abbreviation.
#'
#' @return nothing returned
#' @export
#'
#' @examples
#' if(interactive()){
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       use_access(),
#'       h3("App title")
#'     ),
#'     server = function(input, output, session){
#'       set_lang(session, "en")
#'     }
#'   )
#' }
set_lang <- function(session, lang = "en"){
  shiny::observe(session$sendCustomMessage("add_lang", lang))
}

#' Add role attributes
#'
#' Add role language attribute to key Shiny widgets.
#'
#' You can inspect the element in your browser to verify the addition of role
#' attributes for the following Shiny elements.
#'
#' \itemize{
#'   \item \code{tabsetPanel}
#'   \item \code{tabPanel}
#' }
#'
#' @param session Shiny session.
#'
#' @return nothing returned
#' @export
#'
#' @examples
#' if(interactive()){
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       use_access(),
#'       h3("App title"),
#'       tabsetPanel(
#'         tabPanel("panel1", "Content"),
#'         tabPanel("panel2", "Content")
#'       ),
#'       tabsetPanel(
#'         tabPanel("panel1", "Content"),
#'         tabPanel("panel2", "Content"),
#'         type = "pills", id = "tsp2"
#'       )
#'     ),
#'     server = function(input, output, session){
#'       set_roles(session)
#'     }
#'   )
#' }
set_roles <- function(session){
  shiny::observe(session$sendCustomMessage("add_roles", ""))
}
