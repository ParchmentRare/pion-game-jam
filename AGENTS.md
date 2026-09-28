# AGENTS.md

## Project Overview

This is a game jam demo built around the theme **“Pass It On.”**

The player controls a character who can create and control a temporary ghost. The ghost can pass through walls and interact with objects that the living player cannot reach. The player must use the ghost to manipulate the environment, then reclaim control of the living character and reach the goal.

The core gameplay loop is:

1. Explore the room as the living player.
2. Create and possess a ghost.
3. Pass control to the ghost.
4. Move the ghost through walls and obstacles.
5. Interact with switches, doors, platforms, or other objects.
6. Return control to the living player.
7. Use the changed environment to reach the exit.
8. Repeat with increasingly difficult puzzles.

The demo should prioritize a complete, understandable gameplay loop over large amounts of content.

---

## Development Priorities

Work in this order:

1. Make the core possession mechanic fun and reliable.
2. Build one fully playable puzzle from start to finish.
3. Add visual and audio feedback so the mechanic is easy to understand.
4. Add a small number of additional puzzle variations.
5. Polish controls, UI, effects, and game feel.
6. Avoid adding features that are not required for the core demo.

Do not begin by building a large level system, save system, inventory system, or complex dialogue system unless they become necessary.

---

## Core Gameplay Requirements

### Living Player

The living player must be able to:

- Move left and right.
- Jump or otherwise navigate the environment.
- Collide with walls and solid objects.
- Interact with relevant objects.
- Create a ghost when the ability is available.
- Regain control after the ghost completes its task or the player chooses to return.
- Reach a clearly marked goal or exit.

### Ghost

The ghost must be able to:

- Spawn from the living player.
- Receive player input after possession.
- Move independently from the living player.
- Pass through walls and other solid geometry.
- Interact with designated puzzle objects.
- Have a clear visual difference from the living player.
- Return control to the living player.
- Be destroyed, recalled, or reset if it becomes stuck.

The ghost should not be able to solve every problem automatically. Its interaction abilities should be limited to specific objects so that puzzles remain readable and intentional.

### Passing Control

Control transfer is the primary expression of the theme.

Implement a clear state machine with at least these states:

```text
LivingPlayerControlled
GhostControlled
TransitioningToGhost
ReturningToPlayer
PuzzleComplete

Only one entity should receive movement input at a time.

When control changes:

	Disable movement input on the inactive entity.
	Preserve the inactive entity's position.
    Clearly communicate which entity is currently controlled.
    Prevent accidental repeated spawning or possession.
    Play a transition effect or sound.

Recommended Core Architecture

Use separate systems or components for the following responsibilities:
PlayerController

Responsible for:

    Movement.
    Jumping or navigation.
    Collision.
    Player interaction input.
    Requesting ghost creation.
    Requesting control transfer.

GhostController

Responsible for:

    Ghost movement.
    Ghost collision behavior.
    Passing through walls.
    Ghost-specific interactions.
    Returning control to the living player.

PossessionManager

Responsible for:

    Tracking the living player and ghost.
    Tracking the current control state.
    Spawning and destroying the ghost.
    Switching input ownership.
    Preventing invalid state transitions.
    Returning control safely.

Suggested interface:
text

SpawnGhost()
PossessGhost()
ReturnToPlayer()
DestroyGhost()
CanCreateGhost()
GetCurrentControlledEntity()

InteractionSystem

Responsible for:

    Detecting nearby interactable objects.
    Checking whether the living player or ghost is allowed to interact.
    Sending interaction events.
    Displaying interaction prompts.

Each interactable object should define:
text

CanInteract(actor)
Interact(actor)
InteractionPrompt

PuzzleObject

Create reusable puzzle components such as:

    Switches.
    Levers.
    Pressure plates.
    Doors.
    Moving platforms.
    Timed gates.
    Pushable objects.
    One-way barriers.
    Goal triggers.

Avoid hard-coding individual puzzle solutions into the player controller.
LevelManager

Responsible for:

    Starting and resetting a level.
    Detecting level completion.
    Reloading the current puzzle.
    Moving to the next level or ending the demo.
    Providing a simple restart option.

UIManager

Responsible for:

    Showing the current control state.
    Showing whether the ghost ability is available.
    Displaying interaction prompts.
    Explaining controls.
    Showing level completion and restart instructions.

Input Requirements

Define input actions rather than hard-coding keyboard keys.

Required actions:
text

Move
Jump
CreateGhost
PossessGhost
ReturnToPlayer
Interact
RestartLevel
Pause

Suggested default controls:
text

Move: A/D or Left/Right
Jump: Space
Create/Possess Ghost: E
Return to Player: E or Q
Interact: E
Restart Level: R
Pause: Escape

The final controls may differ depending on the engine, but they must be displayed to the player before or during the first level.
Ghost Rules

Use the following rules unless a level specifically overrides them:

    Only one ghost may exist at a time.
    The ghost spawns near the living player.
    The ghost can pass through walls.
    The ghost cannot activate every object in the scene.
    The living player cannot control the ghost and move at the same time.
	The living player's body remains in the world while the ghost is controlled.
	The living player should be vulnerable to environmental hazards only if hazards are part of the design.
	The ghost should have a maximum range, duration, or resource limit only if needed for puzzle design.
	If the ghost becomes trapped or moves outside the playable area, provide a recall or reset option.

Do not add a ghost timer unless it improves the puzzle design. A timer can make the mechanic stressful before the basic interaction is understandable.
Puzzle Design Requirements

Each puzzle should communicate three things clearly:

	What the player needs to accomplish.
	What the ghost can interact with.
	How the ghost's action changes the path for the living player.

Recommended first puzzle:

    The living player starts in a room separated from the exit by a wall.
    A ghost-accessible switch is placed on the other side of the wall.
    The player creates the ghost.
    The ghost passes through the wall.
    The ghost activates the switch.
    The door opens.
    The player returns to the living character.
    The player walks through the door and reaches the goal.

Recommended progression:
Puzzle 1: Basic Wall Passing

Teach:

    How to create the ghost.
    How to control the ghost.
    How to pass through a wall.
    How to interact with a switch.

Puzzle 2: Remote Door

Introduce:

    A switch located away from the door.
    A need to return control at the correct time.
    A visual connection between the switch and the door.

Puzzle 3: Timing or Sequence

Introduce one of:

    A timed switch.
    Multiple switches.
    A sequence of interactions.
    A moving platform activated by the ghost.

Puzzle 4: Final Demonstration

Combine two or three previously introduced mechanics without adding a completely new rule.

Keep the demo short enough to finish in one sitting. A good target is approximately 5–15 minutes.
Interaction Design

All interactable objects should provide feedback when:

    The ghost is close enough to interact.
    The object can be activated by the current actor.
    The object has been activated.
    The object cannot be used by the current actor.

Use a consistent visual language:

    Living-player interactions: warm or solid colors.
    Ghost interactions: cool, transparent, or glowing colors.
    Disabled interactions: muted colors.
    Completed objectives: a persistent state change.

For example:

    Switches glow when the ghost can use them.
    Doors visibly change state when opened.
    A line, particle trail, or pulse can connect a switch to the object it affects.
    The ghost can leave a short trail while moving through walls.

Avoid relying only on text instructions. The environment should demonstrate the mechanic visually.
Camera and Control Requirements

The camera must make both entities easy to understand.

If the ghost and living player are visible at the same time:

    Keep both entities on screen when practical.
    Use an indicator showing the currently controlled entity.
    Use a screen effect, outline, or camera transition when control switches.
    Avoid making the player lose track of the living body.

If the ghost can move far away:

    Either keep the camera centered on the controlled entity,
    or show an off-screen marker pointing toward the inactive entity.

The player must always understand where their living body is located.
Visual Requirements

Create a clear visual distinction between:
Living Player

    Solid sprite or model.
    Normal shadow.
    Standard movement effects.

Ghost

    Transparent or semi-transparent appearance.
    Distinct color palette.
    Glow, outline, particles, or trailing effect.
    A clear possession indicator when controlled.

Required visual feedback:

    Ghost spawn effect.
    Ghost possession transition.
    Ghost return transition.
    Ghost interaction effect.
    Door or switch state changes.
    Goal completion effect.
    Level reset feedback.

Use simple placeholder assets first. Replace them with polished art only after the gameplay works.
Audio Requirements

Add audio feedback for:

    Ghost creation.
    Taking control of the ghost.
    Returning to the living player.
    Ghost interaction.
    Switch activation.
    Door opening.
    Level completion.
    Failed or invalid interaction.

Audio is not required for the first prototype, but should be added before final presentation if time permits.
Camera and Level Boundaries

Implement safeguards so that the player or ghost cannot permanently break the level:

    Clamp movement to the playable area.
    Detect if the ghost leaves the level bounds.
    Provide a ghost recall function.
    Allow the player to restart the current level.
    Reset puzzle objects to their initial state.
    Ensure the living player cannot spawn inside solid geometry.
    Ensure the ghost cannot spawn outside the intended play area.

The restart action should be quick and reliable.
Suggested Implementation Order
Phase 1: Project Setup

    Create the project and main scene.
    Add a basic test room.
    Add placeholder player and ghost visuals.
    Set up input actions.
    Set up basic collision layers.
    Add a simple goal trigger.

Phase 2: Living Player

    Implement horizontal movement.
    Implement jumping or basic navigation.
    Implement collision with solid objects.
    Add a basic interaction prompt.
    Confirm the player can reach the goal without the ghost.

Phase 3: Ghost Prototype

    Add ghost spawning.
    Make the ghost visually distinct.
    Allow the ghost to pass through walls.
    Add ghost movement.
    Add ghost destruction or recall.
    Confirm that only the active entity receives movement input.

Phase 4: Possession System

    Implement the control state machine.
    Add possession input.
    Add return-to-player input.
    Add transition effects.
    Prevent duplicate ghosts.
    Handle invalid state transitions.

Phase 5: Interactions

    Create a reusable interactable interface or component.
    Implement a ghost-only switch.
    Implement a door controlled by that switch.
    Add interaction feedback.
    Confirm that the complete basic puzzle works.

Phase 6: Puzzle Content

    Create the first tutorial puzzle.
    Create two or three additional puzzle rooms.
    Reuse existing systems instead of creating one-off scripts.
    Add reset functionality to every room.
    Add a final goal or completion screen.

Phase 7: Presentation and Polish

    Add title screen or simple start prompt.
    Add control instructions.
    Add visual transitions.
    Add sound effects.
    Improve lighting, colors, particles, and UI.
    Add a clear ending.
    Test the complete demo from start to finish.

Acceptance Criteria

The demo is considered complete when:

    The player can start a level.
    The player can move the living character.
    The player can create exactly one ghost.
    The player can take control of the ghost.
    The ghost can pass through walls.
    The ghost can activate at least one puzzle object.
    The puzzle object changes the level state.
    The player can return control to the living character.
    The living character can use the changed level state to reach the goal.
    The level can be restarted without restarting the entire application.
    The player understands the controls without developer assistance.
    The game has at least one polished, complete puzzle.
    The game has a clear success state.
    No required puzzle can become permanently unwinnable through normal input.

Testing Checklist

Test the following cases:
Possession

    Attempt to create a ghost while one already exists.
    Attempt to possess the ghost from too far away.
    Return to the player immediately after possessing the ghost.
    Return to the player after moving the ghost far away.
    Restart while controlling the ghost.
    Pause and unpause while controlling the ghost.

Movement

    Walk into walls as the living player.
    Walk through walls as the ghost.
    Jump near walls and doors.
    Move against level boundaries.
    Check for stuck positions after returning from ghost control.

Interactions

    Interact with a switch as the living player.
    Interact with a switch as the ghost.
    Interact from outside the valid range.
    Activate an object more than once.
    Reset the level after activating an object.
    Confirm all puzzle objects return to their initial state.

Completion

    Reach the goal before activating the required switch.
    Reach the goal after solving the puzzle.
    Complete the final level.
    Restart after completion.
    Confirm the player receives clear success feedback.

Code Quality Guidelines

    Keep player movement, ghost movement, possession, interactions, and level logic separate.
    Prefer reusable components over level-specific conditionals.
    Avoid putting puzzle logic directly inside the player controller.
    Use descriptive names for states, events, and interactable objects.
    Keep tuning values configurable.
    Comment only where the reason for the code is not obvious.
    Remove temporary debug controls before the final build.
    Add debug tools only behind a development flag or debug mode.
    Avoid premature optimization; prioritize reliable game feel and clear behavior.

Tunable Configuration

Keep these values easy to adjust:
text

Player movement speed
Player jump height
Ghost movement speed
Ghost spawn offset
Ghost interaction range
Ghost maximum distance, if used
Possession transition duration
Interaction cooldown
Door opening duration
Switch reset behavior
Level restart behavior

These values should not be scattered across unrelated scripts.
Debug Tools

During development, add optional debug features such as:

    Display current possession state.
	Display the ghost's interaction range.
	Show collision bounds.
	Reset the current room.
	Teleport the player to the start.
	Spawn or destroy the ghost.
	Complete the current puzzle.
	Print state transitions.

Remove or disable these tools in the final demo build unless they are intentionally part of the experience.
Scope Protection

Do not add the following until the core demo is complete:

	Multiple ghost types.
	Online multiplayer.
	Complex inventory systems.
	Large open-world levels.
	Procedural level generation.
	Advanced enemy AI.
	Elaborate dialogue systems.
	Multiple endings.
	Complex save data.
	Cinematics longer than the gameplay experience.

If time is limited, prioritize:

	One excellent puzzle.
	Reliable possession controls.
	Clear visual feedback.
	A complete start-to-finish build.

Final Build Requirements

Before creating the final build:

	Start the game from a clean launch.
	Confirm the first level teaches the mechanic.
	Confirm all controls are visible or discoverable.
	Play through the demo without debug tools.
	Verify that restarting works.
	Verify that the game can be completed without external instructions.
	Confirm the final goal and completion state are obvious.
	Package the build with any required assets or configuration files.
	Test the packaged build on the target platform.
