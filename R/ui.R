my_ui <- function(){

  fluidPage(
    # theme = OSUICode::nes_theme,
    theme = bs_theme(bootswatch = 'sketchy'),
    h2('Rules'),
    'Negative numbers move only to the right',
    br(),
    'Positive numbers move only to the left',
    br(),
    'A number can move if it has an empty space in front of it, or a number of different sign followed by an empty space in front of it',
    br(),
    'You win if you move all positive numbers to the left of the empty space, and all the negative numbers to the right of the empty space',
    br(),
    "You lose if it's not possible to make a valid move",
    hr(),
    numericInput('crew_size', 'crew size', value = 7),
    sidebarLayout(
      # Sidebar with a slider and selection inputs
      sidebarPanel(
        actionButton('play', 'Play!'),
        actionButton('clue', 'Make the right move for me!')
      ),
      mainPanel()
    ),
    uiOutput('crew'),
    textOutput('result')
  )

}
