open State
open Command

module type Player = sig
  val init : string -> board
  val make_move : state -> bool
end

module Human : Player = struct

  (* Takes list of ships, counter, and state (simply for the sake of do')
     and alters state. Returns unit *)
  let rec init_help lst i st =
    if i<(List.length lst) then
      let ship = List.nth lst i in
      let name = fst ship in let size = string_of_int(snd ship) in
      print_endline("Where do you want to place your "^name^" of length "^size^"?
      Please enter in the form of \"x1 y1 x2 y2\", all of which are integers, where x1 y1 is the head and x2 y2 is the tail of the ship");
      let c = Command.parse ("place"^" "^name^" "^(read_line ())^" "^size) in
      let step = do' c st in
        if step then (print_newline(); init_help lst (i+1) st)
        else (print_endline("\nInvalid Input. Try again."); init_help lst i st)
    else ()

  (*sets the board for the individual player*)
  let init str =
    print_endline("\nHello "^str);
    print_endline("Would you like to randomly place your ships? yes/no");
    let rec get_command str = try Command.parse str with _ ->
      print_endline("Please type \"yes\" or \"no\". Would you like to randomly place your ships? yes/no");
      get_command (read_line()) in
    let c = get_command (read_line()) in
    if (c == Yes)
    then
      begin
        let board = init_random_board() in
        print_endline("Finished placing your ships");
        board (*initialize random board for user*)
      end
    else
      (print_endline("Begin placing your ships");
      let board = init_board() in
      let st = init_state board board in
      (* run through all of the the ships: ("Carrier", 5),("Battleship", 4),
       * ("Submarine", 3), ("Cruiser", 3), ("Destroyer", 2)
       * and at the end update the state with this new board and a random board
       * for the AI and then call next_state*)

      init_help all_ships 0 st; print_endline("Finished placing your ships"); board)


  let make_move st =
    print_endline ("Where would you like to attack?\n\n"^
       "Valid moves are the following:\n"^
       "-Typing \"attack x y\" where x and y are integers, hits the tile at (x,y) if it has not already been attacked.\n"^
                   "-Typing \"look\" will display the coordinates of your ships. This will not end your turn.\n"^
                   "-Typing \"quit\" terminates the game.\n");
    try
      let rec get_command str = match str with
        | Look -> print_endline(desc st); get_command (Command.parse (read_line()))
        | _ -> str in
      let c = get_command (Command.parse (read_line())) in
      do' c st
    with _ -> false
end


module DumbAI : Player = struct
  let init str = print_endline("Placing AI's ships"); init_random_board()

(* Generate random coordinates to attack
  do' does all the checks to see if it it a proper place to attacked
  will re-run if not a valid place to attack*)
  let rec make_move st =
    if (do' (Attack (Random.int 10, Random.int 10))  st)
    then true
    else make_move st
end

module SmartAI : Player = struct
  let init str = init_random_board()

(*to make checks of where we want to attack:
 * want to check if it has hit any tiles yet
 * if not, randomly choose which coordinates to attack
 * if so, see if all those tiles correspond to a ship that has already sunk
 * if the ship was already sunk that is equivalent to not knowing where to hit next
 * if there are two or more consequetive tiles that have been "hit" then continue
 * to hit down that line (choose which side correctly)*)
  let space = ref 2
  let last_move = ref (4,4)
  let guesses = ref [(4,4)]

  let rec random_move st tiles =
    let x = Random.int 10 in
    let y = Random.int 10 in
    if (not tiles.(x).(y).hit) && ((x+y) mod !space) = 0
    then let _ = do' (Attack (x,y)) st in last_move := (x,y)
    else random_move st tiles

  let rec dir_move tiles (a,b) x y =
    let tile = tiles.(a+x).(b+y) in
    if tile.hit then
      if tile.contains_ship then dir_move tiles (a+x,b+y) x y
      else None
    else Some (a+x, b+y)

  let hunt_move base st tiles =
    let moves = [
      dir_move tiles base 1 1;
      dir_move tiles base (-1) 1;
      dir_move tiles base 1 (-1);
      dir_move tiles base (-1) (-1)
    ] in
    List.iter (fun x -> match x with
      | None -> ()
      | Some x -> guesses := x::(!guesses)) moves;
    match !guesses with
    | [] -> random_move st tiles
    | (x1,y)::tl -> let _ = do' (Attack (x1,y)) st in last_move := (x1,y); guesses := tl


  let check_space board tiles =
    let sunk_ships = List.fold_left
    (fun acc x -> if x.sunken then (x.name)::acc else acc) [] board.player_ships in
    if List.mem "Destroyer" sunk_ships then
      if List.mem "Cruiser" sunk_ships && List.mem "Submarine" sunk_ships then
        if List.mem "Battleship" sunk_ships then space := 5
        else space := 4
      else space := 3
    else ()


  let make_move st =
    let board = if st.p1_turn then st.p2_board else st.p1_board in
    let tiles = board.tiles in
    match !guesses with
    | [] -> let (x,y) = !last_move in
      if not tiles.(x).(y).contains_ship then begin (random_move st tiles); true end
      else begin let _ = check_space board tiles in hunt_move (x,y) st tiles; true end
    | (x,y)::tl -> guesses := tl; let _  = do' (Attack (x,y)) st in last_move := (x,y); true
end

(*human*)
(* let print c st = if (check_game_completed st)
   then print_endline (win_message st)
   else
    match c with
    | NewGame -> print_endline("Starting new game")
    | Coordinate -> print_endline("Need to get rid of this - unnecessary")
    (* |  -> print_endline("Placing ship at " ^ string_of_int x ^ " " ^ string_of_int y) *)
    | Attack (x,y) -> if (already_hit x y st) then print_endline ("You already attacked there. Try again")
      else print_endline("Attacking : " ^ string_of_int x ^ " " ^ string_of_int y)
    | Quit -> print_endline("Exiting game. Goodbye")
    | _ -> print_string (">Valid moves are the following:
            \n"^ "  \"attack (x) (y)\" hits the tile at (x,y)
            if it has not already been attacked.\n"^
                         "  \"quit\" terminates the game. \n \" new game \" starts a new game.\n
            \"help\" will show this again.") *)

(*next_state*)
(* let rec next_state state p1 p2 =
   print_string (">Where would you like to attack? \n Valid moves are the following:
   \n"^ "  \"attack (x) (y)\" hits the tile at (x,y)
   if it has not already been attacked.\n"^
   "  \"quit\" terminates the game.\n
   Inputting \"help\" will show this again. \n
   \" new game \" starts a new game.");
   let c = Command.parse (read_line ()) in
   let st = do' c state in print c st;
   if (st == false) then print_endline ("Invalid move")
   else print_endline ("Hit/Missed??? IDK");
   next_state st *)
