open Player
open State

module type Engine = sig
  (* val init : state -> state *)
  val run : unit -> unit
end

module MakeEngine =
  functor (P1 : Player)
    -> functor (P2 : Player)
      -> struct

        let rec run() =
          let b1 = P1.init "Player 1" in
          let b2 = P2.init "Player 2" in
      let st' = init_state b1 b2 in

      while (not st'.game_completed) do
      if (st'.p1_turn) then
        (print_endline("\nPlayer 1, your turn. \nYour guesses so far:\n"^desc_b st');
        if (P1.make_move st')
        then ((st'.p1_turn <- false); print_endline("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"))
        else print_endline("\nInvalid Input. Player 1 go again."))
      else
        (print_endline("\nPlayer 2, your turn. \nYour guesses so far:\n"^desc_b st');
        if (P2.make_move st')
        then ((st'.p1_turn <- true); print_endline("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"))
        else print_endline ("\nInvalid Input. Player 2 go again."))
    done;
    if (List.fold_left (fun acc x -> acc && x.sunken) true st'.p1_board.player_ships)
      then print_endline("Player 2 wins!")
    else if (List.fold_left (fun acc x -> acc && x.sunken) true st'.p2_board.player_ships)
      then print_endline("Player 1 wins!")
    else print_endline("You have quit the game.")

(*init for Engine's init simply call the different player's init
  because only human needs something printed out*)
(* let init p1 p2 =
   run (init_state (p1.init()) (p2.init())) p1 p2 *)
end
