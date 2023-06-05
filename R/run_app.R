#' @export
run_app <- function(){

  shinyApp(ui = my_ui(), server = my_server, options = list(launch.browser = TRUE))

}
