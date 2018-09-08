(* A type exposed and defined in a .mli file must also be defined in
 * the corresponding .ml file.  So you must repeat the definition
 * of [command] here.  This helps OCaml achieve something called
 * "separate compilation"*)


type command =
  | Place of (int * int) * (int * int) * string * int
  (*the coordinates where the user would want to attack*)
  | Attack of int*int
  | Yes
  | No
  | Look
  | Quit



let parse str =
  let int_arr = String.split_on_char ' ' str in
  let com = String.trim (String.lowercase_ascii (List.nth int_arr 0)) in
  match com with
    | "yes" -> Yes
    | "no" -> No
    | "quit" -> Quit
    | "place" -> let name = List.nth int_arr 1 in
      let x1 = int_of_string (List.nth int_arr 2) in
      let y1 = int_of_string (List.nth int_arr 3) in
      let x2 = int_of_string (List.nth int_arr 4) in
      let y2 = int_of_string (List.nth int_arr 5) in
      let size = int_of_string (List.nth int_arr 6) in
      Place ((x1,y1), (x2,y2), name, size)
    | "attack" -> let x1 = int_of_string (List.nth int_arr 1) in
      let y1 = int_of_string (List.nth int_arr 2) in
      Attack (x1,y1)
    | "look" -> Look
    | _ -> failwith "Invalid command"
