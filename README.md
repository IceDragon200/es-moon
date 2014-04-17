es-moon
=======

Earthen - Smiths built atop moon

So we need to symlink/ or copy the core data into ./core

Since we can't load any external data, except for audio and graphics,
all the game's data is written in ruby (maps, characters etc..),
but this also means we have no save data either :(


## How to spin up ES moon

First up you'll need a copy of moon (archSeer/moon)

```bash
# symlink or copy moon/core to the root of es-moon
ln -s moon/core es-moon/core
```

```bash
# symlink or copy moon/bin/host/game to the root of es-moon
ln -s moon/bin/host/game es-moon/game
```

Execute "game", or use the "play" helper script

If your name is archSeer or IceDragon, then this should work correctly.

### Optional [in case all else fails]

In case that the above was false, you may need some graphical resources that weren't
included due to licensing.

In that case, I can't really help you ^~^;


## Journal of a rambling dragon

* 2014/04/10

  Decided to start a journal, a mruby Numeric#round bug has stabbed me
  in the foot, I've quickly worked around it by just using #to_i for now.


* 2014/04/11 (later that morning/night ?)

  Float#round has been fixed upstream


* 2014/04/11 [7:46 PM]

  We now have IO and YAML, I don't think I'll be porting anything big yet though.

  Probably use it for save data?


* 2014/04/12 [8:29 PM]

  Staring at the code


* 2014/04/12 [10:34 PM]

  Threw out the old PaintMap class for the new v2 version which is much
  easier to use (big thanks to archSeer)

  Now I should work on that Map format...


* 2014/04/12 [10:40 PM]

  Yay! fixed my horrible markdown


* 2014/04/12 [9:25 PM]

  Programmers remorse, I just wasted the day fixing the passage stuff.

  BUT IT WAS WORTH IT!!!

* 2014/04/13 [9:46 PM]

  So I just realized that writing maps in code is going to get ugly fast,
  about time we start on that internal map editor I guess.


* 2014/04/17 [1:04 AM]

  For some odd reason, the best time to work is in the night when its nice
  and cool, however its bad for my health!


* 2014/04/17 [2:04 AM]

  Why am I still awake at a time like this?

  I haven't even put any code to the game!

  Aha, at least I started on some notes, that way I can figure out the
  floorplan for the school I guess?

## FAQ

FYI, WE HAVE NO FAQS, OR FAX, just saying ya know.