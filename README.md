# OSRS Showdown

It's sort of like OSRS combat but you don't have to grind for the gear.

Also like Tales of Mej'Eyal in a way since it's tile-based.

## Feature roadmap

1. Draw characters with positions in a tile-based view
2. Get your character moving to a position when you click; add a ticks system for timing movement
3. Enable simple combat where characters can attack characters in adjacent tiles
	1. Show health bars above all characters
4. Make a full game loop: Lose when you die, go back to menu.

That's the super prototype that doesn't take into account right clicking, prayers, equipment, or inventory with consumables. I'd say we should start with that before we get discouraged.

## 10/13/2024

It looks like I've got something sort of like a full game loop. What can I work on?

- Have enemies attack you back, or have them attack in the first place
  - Have enemy travel to the player (not wander) when attacking back
- Bug: when you first open up the action menu, it disables the UI elements
	until you open another
- Have the base_character script control the commonalitites between enemies and the player (most things except controls)
- Have multiple enemies that one can attack
- Bug: Damage indicator for the enemy sprite shows up in the wrong position

- (Features that make combat interesting)
  - Terrain obstacles
  - Overhead prayers
  - Stats
  - Equipment

DONE list
- DONE--Bug: after I start attacking, I can move anywhere and keep attacking.
- DONE--Bug: The 'Move here' option doesn't work straight up
- DONE--Add sound effects
- DONE--Bug: Game tick toggle doesn't carry over to next level
- DONE--Have the player follow around enemies that it's attacking
- DONE--Bug: Hovering over tile 0,0 changes it permanently.
Among those, the most exciting is probably sound effects--the music might get really repetitive though so I'll wait on that or turn it off during dev.

After that, I want to fix the bug.
