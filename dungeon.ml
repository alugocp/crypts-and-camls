open Yojson.Basic
open Library
open Sys

let ()=
  let parse_enemy (j:json)=match j with
    | `Assoc obj -> let e=(new enemy) in begin List.iter (fun (a:string*json) -> match a with
        | (k,`String v) when k="name" -> e#set_name v
        | (k,`Int i) when k="health" -> e#set_health i
        | (k,`Int i) when k="damage" -> e#set_dmg i
        | _ -> raise (Yojson.Json_error "Invalid JSON")
      ) obj;e end
    | _ -> raise (Yojson.Json_error "Invalid JSON") in
  let rec parse_room (room:room) (j:json)= match j with
    | `Assoc obj -> List.iter (fun (a:string * json) -> match a with
      | (k,`String v) when k="name" -> room#set_name v
      | (k,`List v) when k="messages" -> List.iter (fun (a:json) -> match a with `String s -> room#add_msg s | _ -> raise (Yojson.Json_error "Invalid JSON")) v
      | (k,`List v) when k="rooms" -> List.iter (fun (a:json) -> room#add_room (parse_room (new room) a)) v
      | (k,`List v) when k="enemies" -> List.iter (fun (a:json) -> room#add_enemy (parse_enemy a)) v
      | _ -> raise (Yojson.Json_error "Invalid JSON")
    ) obj;room
    | _ -> raise (Yojson.Json_error "Invalid JSON") in
  let j=(from_file ("adventures/"^(argv.(1))^".json")) in
  let r=new room in (parse_room r j)#enter
