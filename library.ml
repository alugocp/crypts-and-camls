open ANSITerminal
open Printf
open String
open List

module Enemy = struct
  type t =
    { name: string ;
      health: int ;
      dmg: int ; }

  let empty = { name = "" ; health = 0 ; dmg = 0 ; }

  let rec battle t : t=
    if t.health > 0 then begin
      print_string [red] t.name;printf " attacks you for ";
      print_string [red] (string_of_int t.dmg);printf " damage\n";
      printf "What will you do? (";print_string [yellow] "attack";printf ")\n";
      let t =
        let response=read_line() in begin
          printf "\n";
          if response="attack" then (
            let t = {t with health = t.health - 1} in
            printf "You did 1 damage!\n";
            print_string [red] t.name;
            ( if t.health=0
              then printf " is dead!\n"
              else printf " has %i health left\n" t.health );
            t
          ) else (
            printf "Your attack missed\n" ;
            t
          )
        end
      in battle t
    end else t

  let appear t : t =
    printf "An enemy ";print_string [red] t.name;printf " appeared!\n";
    battle t
end

module Room = struct
  type t =
    { enemies: Enemy.t list ;
      messages: string list ;
      rooms: t list ;
      name: string ; }
  let empty = { enemies = [] ; messages = [] ; rooms = [] ;name = ""; }
  let add_msg n t = {t with messages = t.messages@[n]}
  let add_enemy n t= {t with enemies = t.enemies@[n]}
  let add_room n ~parent:({rooms;_} as t) = {t with rooms = rooms@[n]}

  let rec choose_room self :t=
    let input=read_line() in printf "\n";
    match List.find_opt (fun a -> equal a.name input) self.rooms with
    | None -> printf "That's not a room\n"; choose_room self
    | Some room -> enter room

  and priority self : t=
    match self.enemies with
    | [] ->
      if self.rooms <> [] then begin
        iter (fun a -> printf "You can choose to enter ";
               print_string [cyan] a.name;printf "\n") self.rooms;
        choose_room self
      end
      else self
    | enemy::enemies ->
      let self = {self with enemies} in
      let _ = Enemy.appear enemy in
      priority self

  and enter self : t =
    if self.name <> "" then
      (printf "You enter ";print_string [cyan] self.name; printf "\n");
    iter (fun a -> printf "%s " a) self.messages; printf "\n";
    priority self
end
