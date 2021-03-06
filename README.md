# Rogue Beach, CA

**Rogue Beach, CA** is an attempt to create a surf games in the roguelike genre.
No fancy 3D graphics, no stunts, no tunnels, just a beach, water, waves and you,
represented by an **@**, with your board.

  _it's some sort of surfing game I suppose?_ -- legacy99

Website: (ananasblau.com/rogue-beach)[http://ananasblau.com/rogue-beach]

## Srsly, roguelike and surfing?

You gotta be mad to combine a very fast sport like surfing with the
turn-based gameplay of roguelike (though some people just don't get it
on the first try), but I think it can be done with a few tricks. And
let's not forgot, a Rogue Beach will be the ideal game for anyone who's
too slow for surfing or would like to enjoy the wildlife while surfing.

First of all the grid will be a lot small than the usual 1x1m you find
in roguelikes. Secondly the player will have a (very high) speed
parameter so if she goes UP at high speed, a single hit on the LEFT button
will only turn her a little and she will still go UP for a few turns,
dozens of grid blocks.

Roguelikes are a lot about slaying monsters, creatures wouldn't be
expected on a beach. But, beaches offer alternatives: Sharks for
example, but they would be very much to fight, with the surfer just
being part the shark's foodchain. Rocks, though very passive can be a
hazard to anyone falling of their board. Lastely other surfers and even
though this is a sad matter, violence between groups of surfers in order
to claim their stakes on certain beaches or even waves, is not unseen.

  _I'm not sure you understand how roguelikes work..._ -- pekuja

## Gameplay

The player start swith herr board on the beach, grab it, run for the water and
paddle out. Danger might lie in waves crashing in. Once you passed the
waves, wait for a good one (of course the waves are generated randomly,
seeded, and how often does the map completely mutate in a roguelike?)
and paddle like mad, jump and the Fun can start.

Players get scores for a good and long surf, a polished release will give
score if some camera is waiting to get a shot of the surfers.
Trade your score for some hot speedos, flashy bikinis, boards, magic
mushrooms, or a tasty cheeseburger while you are at the beach.

  _looks so neat! Very cool :)_ -- @LorenBendar

## Is this really roguelike?

The checklist according to mikipedia:

1. Prodecually generated, nothing could be more chaotic than waves
2. Turnbased combat (it sure is!)
3. Magic items (Magic Mushrooms from Old Willi's Hippy supply)
4. Permadeath (just wait till you fall and hit the rocks)
5. Single player

So it is, strangely, a roguelike.

  _Rocks!_ -- @Raptorendame

## Screenshots

    +-------+
    |       |
    |   │   |
    | @ │   |
    |   │   |
    |       |
    +-------+

Surfer carrying a board

## Credits

* Sounds by
  * Mike Koenig, CC-By http://soundbible.com/1935-Ocean-Waves.html
* Music by
  * Jano Gonzáles - Kurt Gödel, CC-By-SA http://soundcloud.com/janogonzalez/kurt-godel
  * Jano Gonzáles - Cobquecura, CC-By-SA http://soundcloud.com/janogonzalez/cobquecura
  * Jano Gonzáles - Jugo Blues, CC-By-SA http://soundcloud.com/janogonzalez/jugo-blues
* LÖVE2d and the following libraries:
  * Quickie
* ananasblau's own games Kollum and Cross Country Running

## Participate

OneGameAMonth is about working together, that's why we share all this
sourcecode onto github, that's why you could contribute a few pieces to
this game. Art, music, code, mods, everything is possible, fork the code
right away or mail me. If you want to use my code oot make your own
game, be my guest.

## Features / TODO

* [DONE] Seeded map generator with beach, sea and waves
* [DONE] Player moving around
  * [DONE] When in water, change from a timer to a round based system
  * [DONE] Player laying on surfboard while paddling out to the waves
  * [DONE] Player standing up and surfing
* Graphics
  * Player
  * Surf boards
  * Wild life
  * Promo kit:
    * [DONE] Square app icon
* Waves building up and collapsing
* [DONE] Sound for waves, as audio sources with the Player as listener
  * [DONE] Surf music
* Score
  * awesomeness for certain tricks
  * [DONE] time on the wave
* Beach huts to trade Awesomeness into some gimmick
* Customize Player
  * Surf-board
  * Tattoos
  * Bikini
  * food-stuff
* NPCs
  * Surfers
  * Beachers
  * Kids building castles
  * wild-life:
    * fishies
    * turtles
    * birds
    * sharks
* Scenery
  * [DONE] Rocks (hurt surfer unless riding a wave)
  * Coral reef (like rocks but looking good)
* Beach-wide ranking for Awesomeness, including NPCs (championsships?)
* Replay
  * Record player movements once he's on the board
  * Store gamestate in keyframes every x seconds
  * Play movements

## Word to add (honestly I got no clue why?)

* "Rad" "Bogus" "Bodacious" and "Totally" (Joe Robins)
* "Tabular" (Chris_E)
* "Far Out" and "Kowabunga" (Efranford)

## Videos, images and stuff
To give you an impression of the gameplay and development

* 2013-01-09: improved waves: http://www.youtube.com/watch?v=4D-Z3Xbie8w
* 2013-01-06: first version of the waves http://www.youtube.com/watch?v=jfTced3XgAY

## Authors
* Thomas R. Koll (aka @ananasblau and @TomK32) http://ananasblau.com/games

