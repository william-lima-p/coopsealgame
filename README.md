# coopsealgame
A cool game that I discovered during a leadership training.

In order to run the game, install the package and run `coopsealgame::run_app()`.

During a leadership training, we were presented with the following game:
- Seven of us (including I) were positioned in a row of seven red tiles;
- Each "red player" faced the back of another "red player";
- The other seven of us were positioned in a row of blue seven tiles in the same way, but symmetrically facing the front of the red row;
- Between the red tiles and the blue tiles there was an empty tile;
- We we supposed to move forward, only;
- A person was allowed to move to the empty tile if they were in front of it, or when they were in front of another person with an empty space behind them;
- Only one person was allowed to move at a time;
- The objective was to organize ourselves, so that everyone that started in the blue tiles got onto red tiles, and vice versa.

We had to do that within four minutes, so organization was needed. Everyone was desperate to conclude the task, so we kept saying outloud who should move. Soon enough after some failures, we managed to identify situations where the game was unwinnable. Tjen, all we had to do in order to win was to avoid this unwinnable scenario.
Arriving at home later in the day, I decided to make a code that simulated the game.

To generate an initial state (schema of tiles), we run:
```{r, eval = FALSE}
state <- f.initial_state(n = 15)
```
If moving a number x is allowed, then move it like this:
```{r, eval = FALSE}
state <- state %>% f.swap(x)
```
If you want a suggestion, we have the best move for you!
```{r, eval = FALSE}
state <- state %>% f.winning_move(x)
```
Am I in the unwinnable scenario yet?
```{r, eval = FALSE}
state %>% f.game_over(x)
```
Am I out of moves?
```{r, eval = FALSE}
state %>% f.no_movable_numbers(x)
```
Have I won?
```{r, eval = FALSE}
state %>% f.win(x)
```
I'm bored and just want the solution:
```{r, eval = FALSE}
f.initial_state(n = 15) %>% f.apply_winning_strategy()
```
Anyway, the "moral" of the story during the leadership training was that, at each situation, two people *could* solve the problem, but only one *should*, and it was up to them to figure it out. I don't know if it was the best possible analogy, but at least the game was very interesting.
