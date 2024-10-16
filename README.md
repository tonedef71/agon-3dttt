# agon-3dttt ![3DTTT_ICON](https://github.com/user-attachments/assets/46eb2c7b-be29-4eaf-930d-df9d39de7446)


3D Tic-Tac-Toe is an AgonLight adaptation of the classic two-player strategy game of three-in-a-row, as if played inside of a 3 x 3 cube.

* This adaptation includes an option to play avoidance mode, in which each player must avoid getting three-in-a-row, otherwise they lose.
* It is written in [BBC BASIC v3](https://en.wikipedia.org/wiki/BBC_BASIC) and borrows some of its visuals from Mark Doyle's "3D Tic-Tac-Toe" game for the C-64 which was first published back in June 1984 in Compute's Gazette (issue #12).
* 3D Tic-Tac-Toe may be played on an [AgonLight retro-computer](https://www.olimex.com/Products/Retro-Computers/AgonLight2/open-source-hardware), the [AgonLight Emulator](https://github.com/tomm/fab-agon-emulator/releases), the [Agon Console8](https://heber.co.uk/agon-console8/), or the [BBC BASIC SDL](http://www.bbcbasic.co.uk/bbcsdl/).

# HOW TO PLAY

The object of 3D Tic-Tac-Toe is to be the first player to line up three of their pieces in a row either vertically, horizontally, or diagonally within a 3x3 cube.  However, when the "Avoidance" option is "Y", the object of the game is to avoid being the first player to line up three of their pieces in a row.

## NUMBER OF PLAYERS
When 0 players is selected, the computer will play against itself (as two different players, one as 'X' and the other as 'O'). Some folks enjoy just being a spectator.

When 1 player is selected, the player may compete against the computer. The computer player always plays first as 'X'; the human player follows as 'O'.

When 2 players is selected, two players may compete against each another, alternating turns at the keyboard until a three-in-a-row has been made.

The starting player is always 'X", and so the other player is 'O'.  In a single-player game, the computer player is always the starting player.

## NUMBER OF WINS

The player may select the number of winning rounds needed to win the entire match.  The number of winning rounds needed to win may be any value between 1 and 9.

##  DIFFICULTY LEVEL

For non-two-player games, there are two levels of difficulty.
When 1 is selected, 3D Tic-Tac-Toe plays at its standard level of difficulty.
When 2 is selected, 3D Tic-Tac-Toe plays a slightly more challenging game.

# DISPLAYS
While 3D Tic-Tac-Toe would play fine on multiple display modes, it is currently hardcoded to play on a display mode that supports a minimum of 8 colors and minimum screen dimensions of 40 columns by 24 rows.

For the AgonLight, the display mode is set to MODE 13, and for BBC BASIC SDL the display mode is set to MODE 9.

# CONTROLS
In a one or two player game, a play is made by pressing a key on the keyboard that matches any one of the available locations shown on any of the three tic-tac-toe boards.

```
[A]|[B]|[C]  [J]|[K]|[L]  [T]|[U]|[V]
---+---+---  ---+---+---  ---+---+---
[D]|[E]|[F]  [M]|[N]|[P]  [W]|[Y]|[Z]
---+---+---  ---+---+---  ---+---+---
[G]|[H]|[I]  [Q]|[R]|[S]  [1]|[2]|[3] 
```

In a two player game, players alternate making plays until a three-in-a-row has been made.


# DEMO PLAYTHROUGH
https://github.com/user-attachments/assets/82558423-0868-4882-aaf1-837a46bdccd9

