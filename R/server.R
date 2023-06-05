my_server <-  function(input, output, session) {

  rc.initial_state <-
    reactive({
      f.initial_state(input$crew_size)
    }) %>% bindEvent(input$play)

  rv.current_state <- reactiveVal(NULL)

  observe({

    req(input$play)

    rv.current_state(rc.initial_state())

  }) %>% bindEvent(rc.initial_state())

  observe({

    selected <- as.numeric(input$selected_number)

    shiny::validate(
      need(f.allowed_move(rv.current_state(), selected), 'Movement not allowed!')
    )

    rv.current_state(rv.current_state() %>% f.swap(selected))

  }) %>% bindEvent(input$selected_number)

  output$crew <- renderUI({

    req(rv.current_state())

    lapply(rv.current_state(), function(number){

      if(number > 0){
        paste0("<a href='#' onclick='Shiny.setInputValue(\"selected_number\", \"", ' ', number, "\");' style='font-size: 40px; color:red'>", '&nbsp', number, "</a>") %>% HTML()
      } else if(number < 0){
        paste0("<a href='#' onclick='Shiny.setInputValue(\"selected_number\", \"", number, "\");' style='font-size: 40px; color:blue'>", number, "</a>") %>% HTML()
      } else{
        paste0("<a style = 'font-size:45px'>", "_", "</a>")  %>% HTML()
      }

    })

  })

  observe({

    req(rv.current_state())

    cs <- rv.current_state()

    if(!cs %>% f.win() & !cs %>% f.no_movable_numbers()){

      # browser()

      rv.current_state(cs %>% f.winning_move())

    }

  }) %>% bindEvent(input$clue)

  output$result <- renderText({

    req(rv.current_state())

    if(rv.current_state() %>% f.win()){
      'You win!'
    } else if(rv.current_state() %>% f.no_movable_numbers()){
      'Game over!'
    }

  })



}
