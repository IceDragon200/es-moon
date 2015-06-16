# Battle System
## Variables
| Name         | Human Readable   | Description                                                    |
| ------------ | ---------------- | -------------------------------------------------------------- |
| ap           | Action Points    | Points required to perform actions                             |
| hp           | Health Points    | Points determining an entities health                          |
| mp           | Mana Points      | Points required to use magic or special abilities              |
| wt           | Wait Time        | Time till object is allowed to act                             |
| battle_wt    | Battle Wait Time | The global Wait Time                                           |
| round_wt     | Round Wait Time  | Wait Time allocated to a round                                 |
| rounds       | Round count      | How many rounds have passed since the beginning of the battle  |
| action_index | Action Index     | Limits the number of actions performable per turn              |

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

## WT
Wait Time, is decremented to determine turn order and does not have a "maximum" per say, Wait Time is reset, not by setting its value, but by adding to it.

```ruby
attr_accessor :wt

def wt_default
  # wait time is normally a value around 500
  512
end

def wt_reset
  self.wt += wt_default
end

def wt_turn?
  self.wt < 0
end

def wt_tick
  self.wt -= 1
end
```

## Magic
Cooldown
  Cooldown magic become unavaiable after they are used for a period of time, after the period is over, the magic becomes available once again.

Charged
  Charged magic are similar to cooldown magic, the difference is they require a period to `re-charge`, this effectively renders them useless until the period has passed, this affects magic before their first usage, making them unavailable at the start of a battle.

Casted
  Some magic requires that it is casted, this causes the caster (or user) to gain some Wait Time, therefore delaying their current turn in order to use the skill.

Overdrive
  Overdrive magic causes the caster's final wait time to be doubled, think a Hyper Beam from pokemon for example.

Points
  Some magic has limited number of uses, after all the points have been used the magic becomes unavailable until the points are restored by some method.

Variable Cost
  Most magic can have a variable cost, which affects the strength of the magic and its effects, some magic may allow the caster to use all of their mana to inflict massive amounts of damage, however this leaves the caster very vunerable.

## Faq
q. Why is wt normally added to, instead of set.
a. Skills may carry effects that affect wt, in which they can increase or decrease it, if the wt was set, this would null some effects.
