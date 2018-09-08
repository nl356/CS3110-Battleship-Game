(* open OUnit2
open State

(*******************************************************************)
(* Helper values used throughout this test suite. *)
(*******************************************************************)
let t3 = tile_arr 3

(* Cases we are testing against *)
let tile_array0 =
  [|
    [|{coor=(0,0);hit=false;contains_ship=false};
      {coor=(0,1);hit=false;contains_ship=false};
      {coor=(0,2);hit=false;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=false;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=false;contains_ship=false};
      {coor=(2,2);hit=false;contains_ship=false};
    |]
  |]
let ship0 = [{name="Destroyer"; location=[]; sunken=false}]
let board0 = {player_ships=ship0; tiles=tile_array0}

(* After placing into board0 *)
let tile_array1 =
  [|
    [|{coor=(0,0);hit=false;contains_ship=true};
      {coor=(0,1);hit=false;contains_ship=true};
      {coor=(0,2);hit=false;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=false;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=false;contains_ship=false};
      {coor=(2,2);hit=false;contains_ship=false};
    |];
  |]
let loc1 = [{coor=(0,0);hit=false;contains_ship=true};
            {coor=(0,1);hit=false;contains_ship=true}]
let ship1 = [{name="Destroyer"; location=loc1; sunken=false}]
let board1 = {player_ships=ship1; tiles=tile_array1}

(* After successfully attacking on board0 *)
let tile_array2 =
  [|
    [|{coor=(0,0);hit=true;contains_ship=true};
      {coor=(0,1);hit=false;contains_ship=true};
      {coor=(0,2);hit=false;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=false;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=false;contains_ship=false};
      {coor=(2,2);hit=false;contains_ship=false};
    |];
  |]
let loc2 = [{coor=(0,0);hit=true;contains_ship=true};
            {coor=(0,1);hit=false;contains_ship=true}]
let ship2 = [{name="Destroyer"; location=loc2; sunken=false}]
let board2 = {player_ships=ship2; tiles=tile_array2}


(* After failed attack on board0 *)
let tile_array3 =
  [|
    [|{coor=(0,0);hit=true;contains_ship=true};
      {coor=(0,1);hit=false;contains_ship=true};
      {coor=(0,2);hit=false;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=true;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=false;contains_ship=false};
      {coor=(2,2);hit=false;contains_ship=false};
    |];
  |]
let loc3 = [{coor=(0,0);hit=true;contains_ship=true};
            {coor=(0,1);hit=false;contains_ship=true}]
let ship3 = [{name="Destroyer"; location=loc3; sunken=false}]
let board3 = {player_ships=ship3; tiles=tile_array3}

(* After successfully attacking on board0 *)
let tile_array4 =
  [|
    [|{coor=(0,0);hit=true;contains_ship=true};
      {coor=(0,1);hit=false;contains_ship=true};
      {coor=(0,2);hit=true;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=false;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=false;contains_ship=true};
      {coor=(2,2);hit=false;contains_ship=true};
    |];
  |]
  let loc4 = [{coor=(0,0);hit=true;contains_ship=true};
              {coor=(0,1);hit=true;contains_ship=true}]
  let ship4 = [{name="Destroyer"; location=loc3; sunken=true}]
  let board4 = {player_ships=ship3; tiles=tile_array3}


let tile_array5 =
  [|
    [|{coor=(0,0);hit=true;contains_ship=true};
      {coor=(0,1);hit=false;contains_ship=true};
      {coor=(0,2);hit=true;contains_ship=false};
    |];
    [|{coor=(1,0);hit=false;contains_ship=false};
      {coor=(1,1);hit=false;contains_ship=false};
      {coor=(1,2);hit=false;contains_ship=false};
    |];
    [|{coor=(2,0);hit=false;contains_ship=false};
      {coor=(2,1);hit=true;contains_ship=true};
      {coor=(2,2);hit=false;contains_ship=true};
    |];
  |]

(* let a1111 = ship_fit 11 11 2 false [] {player_ships=[]; tiles=tile_array2}
let a00 = ship_fit 0 0 2 false [] {player_ships=[]; tiles=tile_array2}
let a02 = ship_fit 0 2 2 false [] {player_ships=[]; tiles=tile_array1}
let a21 = ship_fit 2 1 2 false [] {player_ships=[]; tiles=tile_array1} *)




(*******************************************************************)
(* TESTS *)
(*******************************************************************)

let init_tests = [
  (* Initial tiles array *)
  "normal" >:: (fun _ -> assert_equal tile_array0 t3);
]

(* Place/Add *)
let place_tests = [
  (* "11,11" >:: (fun _ -> assert_equal "out of bounds" p1111); *)
  let _ = add_ship board0 [(0,0);(0,1)] "Destroyer" in
  "0,0" >:: (fun _ -> assert_equal board1 board0)
]

(* Attack *)
let attack_tests = [
  (* "11,11" >:: (fun _ -> assert_equal "out of bounds" a1111); *)
  (let _ = attack 0 0 board0 in
   "0,0" >:: (fun _ -> assert_equal board2 board0));
  (let _ = attack 1 1 board0 in
   "1,1" >:: (fun _ -> assert_equal board3 board0));
  (let _ = attack 0 1 board0 in
   "0,1" >:: (fun _ -> assert_equal board4 board0))
]

let suite =
  "Battleship state test suite"
  >::: List.flatten [init_tests; place_tests; attack_tests]

let _ = run_test_tt_main suite *)
