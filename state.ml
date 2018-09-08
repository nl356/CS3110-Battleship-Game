open Command

type tile = {
  mutable coor : int * int;
  mutable hit : bool;
  mutable contains_ship : bool;
}

type ship = {
  name: string;
  location: tile list;
  mutable sunken: bool;
}

type board = {
  mutable player_ships : ship list;
  tiles : tile array array;
}

type state = {
   p1_board : board;
   p2_board : board;
   mutable p1_turn: bool;
   mutable game_completed : bool
 }

(*************************************************************************
    Initialize all types
 *************************************************************************)

(* A list of all possible game ships - names and lengths *)
let all_ships = [
  ("Carrier", 5);
  ("Battleship", 4);
  ("Submarine", 3);
  ("Cruiser", 3);
  ("Destroyer", 2)
]

(* tile_arr helper *)
let init_tile = {coor=(0,0); hit=false; contains_ship=false}

(* Initializes nxn array and fills coordinates *)
let tile_arr n =
  let arr = Array.make_matrix n n init_tile in
  for i = 0 to (n-1) do
    for j = 0 to (n-1) do
      arr.(i).(j) <- {coor=(i,j); hit=false; contains_ship=false}
    done
  done; arr

let init_board () = {
  player_ships = [];
  tiles = tile_arr 10
}

let init_state board1 board2 = {
  p1_board = board1;
  p2_board = board2;
  p1_turn = true;
  game_completed = false
}

(*************************************************************************
    Ship and Board Functions
 *************************************************************************)

let add_ship board coords ship_name =
  let ship =
    {name = ship_name;
     location = List.map (fun (x,y) -> board.tiles.(x).(y).contains_ship <- true;
                           board.tiles.(x).(y)) coords;
     sunken = false} in
  board.player_ships <- ship::board.player_ships


let attack x y board st =
  let hit_tile = board.tiles.(x).(y) in
    hit_tile.hit <- true;
    if not hit_tile.contains_ship then () else
      let hit_ship = List.find (fun x -> List.mem hit_tile x.location) board.player_ships in
      if (List.fold_left (fun acc x -> acc && x.hit) true hit_ship.location)
        then (hit_ship.sunken <- true;
          if (List.fold_left (fun acc x -> acc && x.sunken) true board.player_ships)
            then st.game_completed <- true
            else ())
        else ()

(*************************************************************************
    Functions for initializing random board
 *************************************************************************)

(* Checks if integer [x] fits in the grid *)
let valid_coord x =
  x >= 0 && x <= 9

let rec ship_fit x y size vertical lst board edges =
  let new_lst = (x,y)::lst in
  if List.length new_lst = size then new_lst else
  let edges = if Random.bool() then List.rev edges else edges in
  match edges with
  | [] -> []
  | (a,b)::tl ->
  if vertical then begin
    if valid_coord b && not board.tiles.(a).(b).contains_ship then
      let edges = if List.mem (a, b+1) new_lst then (a,b-1)::tl
        else (a,b+1)::tl in
      ship_fit a b size vertical new_lst board edges
    else ship_fit x y size vertical lst board tl
  end
  else
    if valid_coord a && not board.tiles.(a).(b).contains_ship then
      let edges = if List.mem (a+1, b) new_lst then (a-1,b)::tl
        else (a+1,b)::tl in
      ship_fit a b size vertical new_lst board edges
    else ship_fit x y size vertical lst board tl

(* Helper for init_random_board *)
let rec add_random_ship ship_name size board =
  let x = Random.int 10 in
  let y = Random.int 10 in
  if board.tiles.(x).(y).contains_ship
    then add_random_ship ship_name size board else
    let vertical = Random.bool () in
    let edges =
      if vertical then [(x,y+1);(x,y-1)]
      else [(x+1, y);(x-1, y)] in
    let coords = ship_fit x y size vertical [] board edges in
      if coords = [] then add_random_ship ship_name size board else
      add_ship board coords ship_name

let init_random_board () =
  let board = init_board () in
  List.iter (fun (x,y) -> add_random_ship x y board; ()) all_ships;
  board

(* Helper for make_coords *)
let rec make_lst a x y lst =
  if x = y then (a,y)::lst
  else if x < y then make_lst a (x+1) y ((a,x)::lst)
  else make_lst a (x-1) y ((a,x)::lst)

(* Makes list of coordinates from [x,y] to [a,b]
   Requires: either x=a or y=b *)
let make_coords (x,y) (a,b) =
  if x = a then make_lst x y b []
  else make_lst y x a [] |> List.map (fun (c,d) -> (d,c))

let valid_coords x y =
  valid_coord x && valid_coord y

let valid_attack x y board =
  valid_coords x y && not board.tiles.(x).(y).hit

let valid_place coords board =
  List.fold_left (fun acc (x,y) -> acc && not board.tiles.(x).(y).contains_ship) true coords

let do' command state =
  let my_board = if state.p1_turn then state.p1_board else state.p2_board in
  let enemy_board = if state.p1_turn then state.p2_board else state.p1_board in
  match command with
  | Attack (x,y) ->
    if valid_attack x y enemy_board then
      (attack x y enemy_board state; true)
    else false
  | Place ((x,y), (a,b), str, size)->
    let coords = make_coords (x,y) (a,b) in
    if (List.length coords = size && (x = a || y = b) &&
        valid_coords x y && valid_coords a b
        && valid_place coords my_board)
      then (add_ship my_board coords str; true)
      else false
  | Quit -> state.game_completed <- true; true
  | Look -> false
  | _ -> false


(*************************************************************************
    Description Functions
 *************************************************************************)

(* takes player's board. returns grid: str array array *)
let make_grid board =
  let grid = Array.make_matrix 10 10 " |_ _|" in
  for i = 0 to 9 do
    for j = 0 to 9 do
      if (board.tiles.(i).(j).hit && board.tiles.(i).(j).contains_ship) then
        grid.(i).(j) <- " |_X_|"
      else if (board.tiles.(i).(j).hit && not board.tiles.(i).(j).contains_ship) then
        grid.(i).(j) <- " |_O_|"
    done
  done; grid

(* Helpers for desc_b
   returns string of grid *)
let arr_concat sep arr = Array.fold_left (fun acc s -> acc ^ s) sep arr
let row_string r = arr_concat "\n" r
let rec print_grid grid = arr_concat "" (Array.map row_string grid)


let desc_b state =
  if (state.p1_turn)
  then print_grid(make_grid state.p2_board)
  else print_grid(make_grid state.p1_board)

(* returns string of hit tiles *)
let rec string_hit_tiles t_lst =
  match t_lst with
  | [] -> ""
  | h :: t -> if (h.hit) then
      begin
        let s = "("^(string_of_int (fst h.coor))^","^(string_of_int (snd h.coor))^")" in
        if (h.contains_ship) then s ^ " and it was successful; " ^ string_hit_tiles t
        else s ^ " and you just hit water; " ^ string_hit_tiles t
      end
    else string_hit_tiles t

(* returns string of hit ships *)
let rec string_hit_ships s_lst =
  match s_lst with
  | [] -> ""
  | h :: t -> string_hit_tiles h.location ^ string_hit_ships t

let rec string_tiles t_lst =
  match t_lst with
  | [] -> ""
  | h :: t -> "("^(string_of_int (fst h.coor))^","^(string_of_int (snd h.coor))^") ," ^ (string_tiles t)

let rec string_ships s_lst =
  match s_lst with
  | [] -> ""
  | h :: t -> begin
      let s = h.name ^ " at " ^ string_tiles h.location ^"\n" in
      if (h.sunken) then s ^ " and has been sunken" ^ string_ships t
      else s ^ string_ships t
    end

let string_board mine =
  "\nYour ships:\n" ^ string_ships mine.player_ships (*print the list of the ships*)

let desc st =
  if (st.p1_turn)
  then string_board st.p1_board
  else string_board st.p2_board


(*************************************************************************
    Helper Functions
 *************************************************************************)
(* check game completion. Returns bool *)
(* let check_game_completed state = state.game_completed

(* Helper for win message. Returns winning player *)
let winner state =
  let p1b = state.p1_board.player_ships in
  if List.for_all (fun ship -> ship.sunken) p1b then "Player 1" else "Player 2"

(* win message. Returns string *)
let win_message state =
  "Congratulations " ^ winner state ^ ". You have won the game!!!"

let get_hit_tile board x y = board.(x).(y).hit

let get_contains_ship board x y = board.(x).(y).contains_ship

let get_ships board = board.player_ships *)


(* let rec update_ships x y ships =
   match ships with
   | [] -> []
   | ship::tl -> let new_ship = if List.mem (x,y,false) ship.location then let new_locations = (x,y,true)::(List.filter (fun z -> z <> (x,y,false)) ship.location) in
   {location= new_locations; name= ship.name; sunken= List.fold_left (fun acc (a,b,c) -> acc and c) true new_locations}
   else ship in
   new_ship::(update_ships x y tl)

   let sunk_ships ships =
   List.fold_left (fun acc (_,_,z) -> if z then acc+1 else acc) 0 ships *)
