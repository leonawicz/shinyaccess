#' Add HTML language attribute
#'
#' Add an HTML language attribute to an app.
#'
#' You can inspect the element in your browser to verify. The \code{<html>} tag will include \code{lang="en"} by default.
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
  shiny::observe({
    session$sendCustomMessage("access_lang", lang)
  })
}
