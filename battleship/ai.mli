(* [AI] contains all the board states needed for the AI to work efficiently.
   The dumber AI can simply attack random tiles.
   The smarter AI will have to call the state of the board and act accordingly.*)

open State

(*AIFunctions is a module of all the actions that the AI needs to perform*)
module type AIFunctions = sig

  (*returns the board after they have placed a ship
    randomly generated ship placements and backtracks until an admissible begining
    board is found*)
  val start: board -> board

(*returns the space of where they would like to attack
  For smart: looks at what spaces have already been hit and calculates
  possibilities based off of that
  For dumb: just does this randomly*)
  val attack: state -> state

  (*adds where the ai chooses to attack to a list the previous shots*)
  val mark: state -> int*int list

  (*returns the list of all the sunk ships*)
  val sunk: board -> ship list

  (*checks to see if all the player's ships are sunk*)
  val win_check: board -> bool

end

(*the AI for the game*)
module type AI = sig
  val eval: state -> string
  include AIFunctions
end

(*creates the ai*)
module AIMaker: functor (AIFunctions)
    -> AI

module SmartAI : AI
module DumbAI : AI
