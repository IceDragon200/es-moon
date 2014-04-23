TODO
====

## That Editor!

* ~~Can select a tile~~

* ~~Can place a tile~~

* ~~Can remove a tile~~

* ~~Tile selection panel!~~

* Awesome dashboard thing ma bob

  Just a dropdown panel with save button maybe?
  Also layer buttons, and a toggle button for showing passage editor,
  vs tile editor.


* Saving

  Just dump a YAML file or something...


* Loading

  Just load aforementioned dumped YAML file or something...


* Layer selection panel!?
  If the dashboard doesn't cut it...


## Entity interaction

* ~~Entity System Draft~~

* Add other entities other than the player

  For now something like a sign, this means we'd need a message box I guess?

  * Entities are stored in a quadtree, so that we can fetch and render only
    the ones visible on screen.

  * Entities are built from components, instead of inheritance.

  * Systems operate on filtered ranges of entities.

    Filters are usually whether entity includes a component.

  * The usual practice is that systems contain the processing logic, and entities
    are simply blobs that link together data (components), but since our components
    can/will be done via mixins, that allows for pretty easy logic separation.

    That means systems would just be loops running over a filtered selection of
    entities, and calling the correct method. Though again, we might need a single
    component in multiple systems, mixing the concerns... or we might need multiple
    components in one system.

    So we might just follow the practice of putting the logic into a system component?

  * Entities communicate with each other using a messaging system that triggers
    events (Eventable).

  * Pre-programmed sequences, like a moving pattern, etc. are defined in a behavioral tree
    and AI controllers are basically just stepping over the behavior tree.

    ref: http://gamedev.stackexchange.com/questions/44396/many-sources-of-movement-in-an-entity-system?rq=1

  * Collision detection is done using a system that uses the entity quadtree,
    and only checks between collisions of objects in the same region.

  * Notifying an entity that a player is nearby ("attack me!") can be done by
    notifying the entities in the same quadtree section.

  References:

  http://gamedev.stackexchange.com/questions/31473/role-of-systems-in-entity-systems-architecture
  http://www.randygaul.net/2013/05/20/component-based-engine-design/
  http://www.gamedev.net/page/resources/_/technical/game-programming/understanding-component-entity-systems-r3013
  http://www.gamedev.net/page/resources/_/technical/game-programming/implementing-component-entity-systems-r3382
  http://www.gamedev.net/page/resources/_/technical/game-programming/case-study-bomberman-mechanics-in-an-entity-component-system-r3159
  https://github.com/vinova/Artemis-Ruby
  http://www.richardlord.net/blog/why-use-an-entity-framework


* Setup action triggers! (at least plan them)

  when a collides with b do x, y, z


* Some sort of event system? (we could create a ruby DSL for it)

## Complete the first Area

Chunk > Map > Area
Areas have many Maps, Maps have many Chunks, and Chunks are data


## Minimal Combat!

* Combat...

* Go do a zelda thing for now

* Simple shift system

  Its an old feature from Yggdrasil, by pressing a key you could quickly
  change the player entity to another party member.

* Flying stuff (projectiles)
