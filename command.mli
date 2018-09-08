(* [command] represents a command input by a player. *)
(* Possible inputs that the user can type into our game.
   There are two parts to the command schemes.
   1) Place the five ships onto the player’s own board
   2) Enter in coordinates to attack the opponent’s board
   3) General game commands, like yes, no, and quit *)


(* type [command] is the possible inputs that the user can type in. *)
type command =
  (*the coordinates where the user would place the prompted ship*)
  | Place of (int * int) * (int * int) * string * int 
  (*the coordinates where the user would want to attack*)
  | Attack of int*int 
  | Yes
  | No
  | Look
  | Quit

(**
 * Parses input [str] that is command and returns corresponding type command.
   The commands will be specified in the provided instructions,
   some of which are written in the submitted documentation.
 * requires: [str] be a valid command. spacing and synatx don't matter.*)
val parse : string -> command


(*******************************************************
   Both of the following functions may be omitted if coordinates
   are implemented differently. Like if coordinates are taken in separately
*******************************************************)

(* Parses command input [command] and returns the x-coordinate as a string
   requires: command to be a coordinate *)
(* val get_x : command -> string *)

(* Parses command input [command] and returns the y-coordinate as a string
   requires: command to be a coordinate *)
(* val get_y : command -> string *)
