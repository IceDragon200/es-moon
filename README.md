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

## FAQ

FYI, WE HAVE NO FAQS, OR FAX, just saying ya know.