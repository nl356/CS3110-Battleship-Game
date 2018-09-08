(* GUI module handles the GUI and user interface for the game
look into CamlImages*)

(* [init_welcome f] draws the welcome page *)
(* val init_board : unit -> unit *)

(* [draw_board st] draws the canvas background for the game
 * under current state [st]. *)
(* val draw_board : State.state -> unit *)

(* [update_board st] updates the non-static part of canvas for the game
 * under current state [st]. *)
(* val update_board : State.state -> unit *)


(*online material - these are all the types i think for the functions given*)
(* val draw_box_outline : box_config -> Graphics.color -> unit = <fun>
val draw_box : box_config -> unit = <fun>
val set_gray : int -> Graphics.color = <fun>
val gray1 : Graphics.color = 6579300
val gray2 : Graphics.color = 11184810
val gray3 : Graphics.color = 15790320
val create_grid : int -> int -> int -> box_config -> box_config list = <fun>
val vb : box_config array =
         [|{x=90; y=90; w=20; h=20; bw=2; r=Top; b1_col=6579300; b2_col=15790320;
            b_col=11184810};
           {x=68; y=90; w=20; h=20; bw=2; r=Top; b1_col=6579300; b2_col=15790320;
            b_col=...};
           ...|] *)
