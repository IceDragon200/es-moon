# Battle System
## Abbreviations

## Variables
| name         | Human Readable | Description |
| ------------ | -------------- | ----------- |
| ap           | Action Points | Points required to perform actions |
| hp           | Health Points | Points determining an entities health |
| mp           | Mana Points   | Points required to use magic or special abilities |
| wt           | Wait Time     | Time till object is allowed to act |
| battle_wt    | Battle Wait Time | The global Wait Time |
| round_wt     | Round Wait Time | Wait Time allocated to a round |
| rounds       | Round count | How many rounds have passed since the beginning of the battle                                     |
| action_index | Limits the number of actions performable per turn |

## Phases
* battle_start - Very first phase, initiates the battle

  * round_next - Advances to the next round, in the case of a battle start, this will be round 1

  * round_start - Start phase of a round

    * next_tick - Advances the global tick to the next available event or entity, if `round_wt` is reduced to 0 and no event/entity is obtained, then this will jump to the `round_end`

    * turn_start - Start phase of a entity or event's turn. 

      * action_next - Determine if the actor can make an action, as well as incrementing the entities `action_index`

      * action_make - AI or player makes an action

      * action_prepare - Action is prepared (such as paying costs and all dat jazz)

      * action_execute - Executes the action

      * action_judge - Checks victory or losing conditions, if no conditions have been met, jump back to `action_next`

    * turn_end - End phase of a entity or event's turn.
      At this point, the event dropped from the list, or the entity has its
      wt reset to its maximum value (not by setting it, but by adding to it).

    * turn_judge - Checks victory or losing conditions, if no conditions have been met, jump back to `next_tick` 

  * round_end - End phase of a round

  * round_judge - Checks victory or losing conditions, if no conditions have been met, jump back to `round_next`

* battle_end - Ends the battle

* battle_judge - Checks victory or losing conditions

## Faq
q. Why is wt normally added to, instead of set.
a. Skills may carry effects that affect wt, in which they can increase or decrease it, if the wt was set, this would null some effects.
