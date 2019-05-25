![Logo](logo.png)
-----
A functional text-based dungeon crawler written in OCaml! The name is a bad play on *Dungeons & Dragons*. Play out various adventures in my custom RPG system such as:
* **Zulú Burá**, ancient tomb of the desert kings
* ~~Temple of the gold god **Ahn Juné**~~
* *that's it!*

Seriously, this game has it all!
* [x] Action
* [x] Suspense
* [x] Horror
* [ ] Imperative design

I wanted to try my hand at game creation in this very strange language and I figured a text-based dungeon crawler would be a great place to start. So I dusted off some old dungeon ideas I had from when I was younger and rolled them over into this.

## Installation
Before you can run, make sure you have the `yojson` and `ANSITerminal` modules installed for OCaml. If you're not sure then just run:
```
opam install ANSITerminal
opam install yojson
```

## Run
Just use my built-in `./run <dungeon>` script to build the game in dune and run it
with the specified dungeon (which corresponds to a JSON file in the `adventures` directory). If you don't specify a dungeon then the value `zulubura` will be used by default.

 ## Misc
 That should be all you need to play the game! Just follow the instructions in each room and you'll make it out alive. If you want you could also subscribe to my [YouTube channel](https://youtube.com/alexlugo).
