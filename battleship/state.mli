
(* This module serves to preserve game state.
   It lists out which places of the grid is covered by a ship.
   In the beginning declares types: tiles, ships, boards, and state.
*)

(* [tile] is an abstract type representing a tile on the board. *)
type tile = {
  mutable coor : int * int; (*coordinates of the tile*)
  mutable hit : bool; (*whether or not it has been hit already*)
  mutable contains_ship : bool; (*whether or not there is a ship on the tile*)
}

(* [ship] is an abstract type representing a ship. *)
type ship = {
  name: string;
  location: tile list;
  mutable sunken: bool;
}

(* [board] is an abstract type representing the board of game. *)
type board = {
  mutable player_ships : ship list;
  tiles : tile array array;
}

(* [state] is an abstract type representing the state of game. *)
type state = {
  p1_board : board;
  p2_board : board;
  mutable p1_turn: bool;
  mutable game_completed : bool
}


(* [init_board] returns a 10x10 board initialized with init values for all
   its fields: a list of player's ships and tiles *)
val init_board : unit -> board

(* [init_random_board] returns a 10x10 board initialized with random but valid
   values for all its fields: a list of player's ships and tiles *)
val init_random_board : unit -> board

(* [init_state] returns an initial state given 2 boards
   requires: two valid boards *)
val init_state : board -> board -> state

(* [add_ship] takes a board, coordinates, and ship name and returns
   a board updated with updated ship values.
   requires: Valid board, coordinates, and ship name *)
val add_ship : board -> (int*int) list -> string -> unit

(* [attack] takes coordinates and a board and returns an updated board.
   requires:  Valid coordinates and board *)
val attack : int -> int -> board -> state -> unit

(* [ship_fit] takes numerous data points and returns a coordinate list.
   input: x and y coordinates, the ship's size, whether it's placed vertical or
   horizontal, a coordinate list, and a board.
   requires:  Valid coordinates and board *)
val ship_fit : int -> int -> int -> bool -> (int*int) list -> board -> (int*int) list 
-> (int*int) list

(* [do'] takes a command and a board and returns an updated board 
   based on the command.
   All the checks of validity are done here.
   Because all types are mutable, it only returns boolean for whether it has 
   correctly executed.
   Valid commands are Attack and Place. 
   [Attack] can only be done within boundaries and not previously attacked places.
   [Place] can only be done within boundaries and not previously placed locations.
   requires: A valid command and a valid board*)
val do' : Command.command -> state -> bool

(* [desc] takes a valid board and returns a description.
   requires: A valid state *)
val desc : state -> string

(* [desc_b] takes a valid board and returns an ASCII versiion of the board..
   requires: A valid state *)
val desc_b: state -> string


(* Some exposed types to help with testing and displaying game state *)
val all_ships : (string*int) list
val tile_arr : int -> tile array array
