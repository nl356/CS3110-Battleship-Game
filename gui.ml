open Graphics
open State

let draw_board st = failwith "Unimplemented"

(*************************************************************************
    Initialize all types
 *************************************************************************)

(*(x,y,w,h)*)
type windows = int*int*int*int
type update = windows -> windows

type game_board =
  {
    (*splitting these into two different player boards for now*)
    mutable p1_b: board; 
    mutable p2_b: board;
    mutable win_bounds: int*int;
    (*keep a running log of what has occured (on the side of all the game play*)
    mutable log_window: windows; 
    mutable log: string list; (*what is printed in the log*)
    mutable p_turn: string; (*who's turn it is: print this out in the log *)
    mutable turn_window: windows; (*the button to press and change their turn*)
    mutable turn_text: string;
  }

(*determining who's board to display*)
type turn = P1 | P2

(*determine color of the boxes *)
let my_ship = Graphics.black
let my_ship_hit = Graphics.red
let opp_ship_hit = Graphics.red
let water = Graphics.blue


(*************************************************************************
    Initialized Game Boards
    Taken from already implemented and provided library on the pulic domain
 *************************************************************************)
type relief = Top | Bottom | Flat

type box_config =
  { x:int; y:int; w:int; h:int; bw:int; mutable r:relief;
    b1_col : Graphics.color;
    b2_col : Graphics.color;
    b_col : Graphics.color}

let draw_rect x0 y0 w h =
   let (a,b) = Graphics.current_point()
   and x1 = x0+w and y1 = y0+h
   in
     Graphics.moveto x0 y0;
     Graphics.lineto x0 y1; Graphics.lineto x1 y1;
     Graphics.lineto x1 y0; Graphics.lineto x0 y0;
     Graphics.moveto a b

let draw_box_outline bcf col =
  Graphics.set_color col;
  draw_rect bcf.x bcf.y bcf.w  bcf.h

let draw_box bcf =
   let x1 = bcf.x and y1 = bcf.y in
   let x2 = x1+bcf.w and y2 = y1+bcf.h in
   let ix1 = x1+bcf.bw and ix2 = x2-bcf.bw
   and iy1 = y1+bcf.bw and iy2 = y2-bcf.bw in
   let border1 g =
     Graphics.set_color g;
     Graphics.fill_poly
       [| (x1,y1);(ix1,iy1);(ix2,iy1);(ix2,iy2);(x2,y2);(x2,y1) |]
   in
   let border2 g =
     Graphics.set_color g;
     Graphics.fill_poly
       [| (x1,y1);(ix1,iy1);(ix1,iy2);(ix2,iy2);(x2,y2);(x1,y2) |]
   in
   Graphics.set_color bcf.b_col;
   ( match bcf.r with
         Top  ->
           Graphics.fill_rect ix1 iy1 (ix2-ix1) (iy2-iy1);
           border1 bcf.b1_col;
           border2 bcf.b2_col
       | Bottom  ->
           Graphics.fill_rect ix1 iy1 (ix2-ix1) (iy2-iy1);
           border1 bcf.b2_col;
           border2 bcf.b1_col
       | Flat ->
           Graphics.fill_rect x1 y1 bcf.w bcf.h );
   draw_box_outline bcf Graphics.black


let set_gray x =  (Graphics.rgb x x x)
let gray1= set_gray 100 and gray2= set_gray 170 and gray3= set_gray 240

let rec create_grid nb_col n sep b  =
   if n < 0 then []
   else
     let px = n mod nb_col and py = n / nb_col in
     let nx = b.x +sep + px*(b.w+sep)
     and ny = b.y +sep + py*(b.h+sep) in
     let b1 = {b with x=nx; y=ny} in
     b1::(create_grid nb_col (n-1) sep b)

let vector_boxes =
  let b =  {x=0; y=0; w=20;h=20; bw=2;
       b1_col=gray1; b2_col=gray3; b_col=gray2; r=Top} in
  Array.of_list (create_grid 10 24 2 b)

(*creates the beginning screen*)
let init_board () =
  open_graph ""; set_window_title "Battleship";
  Array.iter draw_box vector_boxes




(*************************************************************************
    Game Play
 *************************************************************************)

(* returns the (x, y) of the next mouse click relative to the window,
 * doesn't terminate until the mouse is clicked in the window *)
let get_next_click_pos () =
  let click = Graphics.wait_next_event [Button_up] in
  (click.mouse_x, click.mouse_y)

(*use this to update the displayed board with the proper picture/color
 * determined by mouse clicks?*)
let attacked x y ship = failwith "Unimplemented"

(*update what is displayed to the board
  - when tiles are guessed*)
let update_board st = failwith "Unimplemented"
