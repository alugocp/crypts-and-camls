open Yojson.Basic
open Library
open Sys

let ()=
  let parse_enemy = function
    | `Assoc obj -> List.fold_left (fun e -> function
        | ("name", `String name)  -> Enemy.{e with name}
        | ("health", `Int health) -> {e with health}
        | ("damage", `Int dmg)    -> {e with dmg}
        | _ -> raise (Yojson.Json_error "Invalid JSON")
      ) Enemy.empty obj
    | _ -> raise (Yojson.Json_error "Invalid JSON") in
  let rec parse_room (room:Room.t) = function
    | `Assoc obj -> List.fold_left (fun room -> function
      | ("name",`String name) -> Room.{room with name}
      | ("messages",`List v) ->
        List.fold_left (fun parent -> function
            | `String s -> Room.add_msg s parent
            | _ -> raise (Yojson.Json_error "Invalid JSON")) room v
      | ("rooms",`List v) ->
        List.fold_left (fun parent (a:t) ->
            Room.add_room (parse_room Room.empty a) ~parent) room v
      | ("enemies",`List v) ->
        let parse_and_add r a = Room.add_enemy (parse_enemy a) r in
        List.fold_left parse_and_add room v
      | _ -> raise (Yojson.Json_error "Invalid JSON")
    ) Room.empty obj
    | _ -> raise (Yojson.Json_error "Invalid JSON") in
  let j=(from_file ("adventures/"^(argv.(1))^".json")) in
  let _ = Room.enter (parse_room Room.empty j) in ()
