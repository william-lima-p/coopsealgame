f.initial_state <- function(n = 15){

  k <- n %/% 2

  c(-rev(1:k), 0, 1:k)

}

f.swap <- function(state, x){

  location <- which(state == x)

  versor <- x / abs(x)

  in_front <- location - versor * 1
  in_leap <- location - versor * 2

  if(!in_front %in% seq_along(state)){
    return(state)
  }

  if(length(state[in_front]) > 0){

    if(state[in_front] == 0){

      state[in_front] <- x
      state[location] <- 0

      return(state)

    } else if(in_leap %in% seq_along(state)){

      if(all(
        state[in_front] * x < 0,
        state[in_leap] == 0 & !is.na(state[in_leap])
      )){

        state[in_leap] <- x
        state[location] <- 0

      }

    }

  }

  return(state)

}

f.allowed_move <- function(state, x){

  moved <- f.swap(state, x)
  any(moved != state)

}

f.game_over <- function(state){

  unwinnable_state <-
    tibble(State = state) %>%
    mutate(Lead = lead(State), Lag = lag(State)) %>%
    mutate(across(c('Lead', 'Lag'), \(x) do.call(cur_column() %>% tolower(), list(x = x)), .names = '{col}_2' )) %>%
    mutate(across(c('Lead_2', 'Lag_2'), \(x) do.call(cur_column() %>% tolower() %>% sub('_.', '', .), list(x = x)), .names = "{col %>% sub('_.', '', .)}_3" )) %>%
    filter(any(
      State > 0 & Lag < 0 & Lag_2 < 0 & Lag_3 >= 0,
      State < 0 & Lead > 0 & Lead_2 > 0 & Lead_3 <= 0
    ))
    # filter(any(
    #   State < 0 & Lag < 0 & Lag_2 == 0,
    #   State < 0 & Lag < 0 & Lag_2 > 0 & Lag_3 == 0,
    #   State > 0 & Lead > 0 & Lead_2 == 0,
    #   State > 0 & Lead > 0 & Lead_2 < 0 & Lead_3 == 0
    # ))

  return(nrow(unwinnable_state) > 0)

}

f.win <- function(state){

  # all(state == -rev(state))
  n = length(state)

  k <- n %/% 2

  all(state == c(1:k, 0, -rev(1:k)))

}

f.keep_positive <- function(x){
  if_else(x >= 0, x, -x)
}

f.movable_numbers <- function(state){

  empty_space <- which(state == 0)

  candidates <- state[f.keep_positive(empty_space - 2):f.keep_positive(empty_space + 2)] %>% .[(.) != 0]

  candidates[sapply(candidates %>% .[!is.na(.)], \(x) f.allowed_move(state, x))] %>% .[!is.na(.)]

}

f.no_movable_numbers <- function(state){
  length(f.movable_numbers(state)) == 0
}

f.winning_move <- function(state){

  movable <- f.movable_numbers(state)

  moved <- f.swap(state, movable[1])

  if(f.win(moved)){return(moved)}

  game_over <- moved %>% f.game_over()

  # if it's not game over, checks if all next possible moves yield in game over anyway
  if(!game_over){

    upcoming_movable <- moved %>% f.movable_numbers()
    if(length(upcoming_movable) > 0){
      if(
        all(upcoming_movable %>% sapply(\(x) x %>% f.swap(moved, .) %>% f.game_over() ))
      ){
        moved <- f.swap(state, movable[2])
      }
    }

  } else if(!is.na(movable[2])){
    # if it's game over, just move the only other movable

    moved <- f.swap(state, movable[2])

  } else{

    moved <- state

  }

  return(moved)

}

f.apply_winning_strategy <- function(state, sleep = 0){

  print(state)

  Sys.sleep(sleep)

  game_over <- state %>% f.game_over()
  win <- FALSE
  while(!win & !game_over){
    state <- state %>% f.winning_move()
    print(state)

    game_over <- state %>% f.game_over()
    win <- state %>% f.win()

    Sys.sleep(sleep)
  }

  return(state)

}
