es-moon
=======

Earthen - Smiths built atop moon

So we need to symlink/ or copy the core data into ./core

Since we can't load any external data, except for audio and graphics,
all the game's data is written in ruby (maps, characters etc..),
but this also means we have no save data either :(

# Journal of a rambling dragon
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