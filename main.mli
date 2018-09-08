open State
open Command

(* [main] brings everything together to play game and prints to interface.
   Remaining functions needed to tie together the previously implemented functions.
   This is where print statements are called.
   This module should also contain checks to make sure that the commands
   passed through from the user are valid. *)



(* [description] takes state [s] and prints any necessary messages.
   Messages include: confirming to quit, switching players, and errors.
   requires: [s] must be a valid state as described in state module.*)
(* val description : state -> unit *)

(* [board] takes state [s] and prints the entire board game.
   The board game is a grid with locations of ships, past moves, and free spaces.
   requires: [s] must be a valid state as described in state module.*)
(* val board : state -> unit *)


(* [print] takes valid commands [c] and states [s] and prints information.
   require: both command and state to be valid based on requirements
   in their respective modules. *)
(* val print : command -> state -> unit *)

(* [check_game_completed] takes state [s] and checks if the game requirements
   to finish a game are fulfilled. Specific properties of finishing a game
   are specified in state module.
   If a game is completed, this prints out a winning message.
   requires: [s] must be a valid state as described in state module.*)
(* val check_game_completed : state -> unit *)


(* [next_state] performs the REPL for the game.
   REPL: reads input, evaluate command on valid state [s], print, and loop
   requires: [s] must be a valid state as described in state module.*)
(* val next_state : state -> state *)


(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
val main : unit -> unit
