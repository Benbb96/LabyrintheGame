# Labyrinthe Game

*Randomly generated maze game created and developed by Benjamin Bernard-Bouissières using the Processing software __[software](https://processing.org/)__*

## Presentation of the game

The goal of the game is obviously to cross labyrinths that are generated randomly thanks to an algorithm called the __Recursive Backtracker__ (see here for more info)
The game starts at level 1 on the green box of a 2 by 2 labyrinth. Each time the player manages to reach the red box, a new labyrinth appears but this time of dimension 3 by 3 and so on. infinite.
The player is timed with each new labyrinth.
An __artificial intelligence__, represented by red pawns, adds an extra difficulty in trying to catch the player by starting from the beginning.
The walls fade away as you go, asking the player to memorize their location or look for the exit.
I also created a little background music that repeats itself in a loop (it can get pretty boring after a while ^^ ').

## Areas of improvement

* Draw the path taken by the player -> Done, P key to enable / disable (improve?)
* Put a background? Animation construction of the labyrinth
* Improved AI -> Disjktra Algorithm -> Moves to a random point for consistency printing in movements.
The AI could make a move each time the player moves (Pokemon Dungeon Mystery)
* Shelter boxes to protect themselves from AIs (in the corners?)
* Adding objects to collect (Powers, score, ...)
* Creating a game menu
* Management of the best scores in a file -> Done (to be used in future menus)
* Adding different sounds
* Extend the labyrinth on both sides instead of generating a new one -> not great because we always go back by the same way
* Make the walls disappear at a certain time. The player must memorize the location of the walls. A special touch could make it possible to review the walls for a short time -> Done, key A
