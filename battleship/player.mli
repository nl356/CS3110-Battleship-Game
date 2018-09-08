open State
open Command

(* This module defines a player, which we later utilized in human,
   smart AI, and dumb AI. Each player is required to implement init and make_move
   [init] essentially acts as placing the ships
   [make_move] attacks the opponent's ships. *)
module type Player = sig
  val init : string -> board
  val make_move : state -> bool
end

(* This module takes in commands from parsing user input*)
module Human : Player

(* This module makes guesses randomly from an RNG *)
module DumbAI : Player

(* This module keeps track of previous guesses and the results of them *)
module SmartAI : Player
