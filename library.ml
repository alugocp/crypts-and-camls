open ANSITerminal
open Printf
open List

class enemy=object (self)
  val mutable name:string=""
  val mutable health:int=0
  val mutable dmg:int=0
  method set_health n=health <- n
  method set_name n=name <- n
  method set_dmg n=dmg <- n

  method appear:unit=
    printf "An enemy ";print_string [red] name;printf " appeared!\n";
    self#battle
  method battle:unit=
    if health>0 then begin
      print_string [red] name;printf " attacks you for ";
      print_string [red] (string_of_int dmg);printf " damage\n";
      printf "What will you do? (";print_string [yellow] "attack";printf ")\n";
      let response=read_line() in begin
        printf "\n";
        if response="attack" then (
          health <- health+(-1);
          printf "You did 1 damage!\n";
          print_string [red] name;
          if health=0 then printf " is dead!\n" else printf " has %i health left\n" health
        ) else printf "Your attack missed\n"
      end;
      self#battle
    end
end

class room=object (self)
  val mutable enemies:enemy list=[]
  val mutable messages:string list=[]
  val mutable rooms:room list=[]
  val mutable name:string=""
  method name=name
  method set_name (n:string)=name <- n
  method add_msg n=messages <- messages@[n]
  method add_enemy n=enemies <- enemies@[n]
  method add_room n=rooms <- rooms@[n]

  method choose_room:unit=
    let input=read_line() in
    printf "\n";
    let next=List.find_all (fun a -> a#name = input ) rooms in
    if (length next)=0 then begin printf "That's not a room\n";self#choose_room end
    else (nth next 0)#enter

  method enter:unit=
    if (String.length name)>0 then (printf "You enter ";print_string [cyan] name;printf "\n");
    iter (fun a -> printf "%s " a) messages;printf "\n";
    self#priority
  method priority:unit=
    if (length enemies)>0 then begin
      (nth enemies 0)#appear;
      enemies <- List.find_all (fun a -> a!=(nth enemies 0)) enemies;
      self#priority
    end else if (length rooms)>0 then begin
      iter (fun a -> printf "You can choose to enter ";print_string [cyan] a#name;printf "\n") rooms;
      self#choose_room
    end
end
