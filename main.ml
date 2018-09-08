open State
open Command
open Engine
open Player

(* let description = failwith "Unimplemented"
   let board = failwith "Unimplemented" *)

module TwoPlayer = MakeEngine(Human)(Human)
module OnePlayer = MakeEngine(Human)(DumbAI)
module OnePlayerSmart = MakeEngine(Human)(SmartAI)
module Smart = MakeEngine(SmartAI)(SmartAI)
module SmartvDumb = MakeEngine(SmartAI)(DumbAI)
module Dumb = MakeEngine(DumbAI)(DumbAI)
(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to Battleship\n");
  print_string  "> ";
  print_endline ("Who is playing this game?
  1. Human vs Human
  2. Human vs DumbAI
  3. Human vs SmartAI
  4. DumbAI vs DumbAI
  5. SmartAI vs SmartAI
  6. SmartAI vs DumbAI
  Please type the number of the game you would like to play: ");
  let rec get_mode str =
    let num = try int_of_string (String.trim (str))
      with _ -> print_endline("please enter a number between 1 and 6");
        get_mode (read_line()) in if num >= 1 && num <= 6 then num
    else get_mode (read_line()) in
  let game = get_mode (read_line()) in
  match game with
  | 1 -> TwoPlayer.run()
  | 2 -> OnePlayer.run()
  | 3 -> OnePlayerSmart.run()
  | 4 -> Dumb.run()
  | 5 -> Smart.run()
  | _ -> SmartvDumb.run()


let () = main ()
