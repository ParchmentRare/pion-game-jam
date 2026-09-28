# Pass It On

Godot 4 platform-puzzle prototype. The main scene owns possession and camera control; level geometry is authored separately.

## Controls

- **A / D** or **Left / Right**: move the knight
- **Space**: jump
- **E**: create and possess one ghost
- **W / A / S / D** or **Arrow keys**: move the ghost
- **Q**: return to the knight
- **F**: use a nearby wall switch
- **R**: restart the current scene

Xbox controls are shown in the in-game legend: **Left Stick / D-pad** move, **A** jumps, **X** creates a ghost, **Y** returns, **RB** uses a switch, and **Menu** restarts.

Keyboard bindings are added when the main scene starts. Existing controller actions remain available.

## Authoring walls and switches

Instance `scenes/phase_wall.tscn` for each colored wall and set its `wall_size` and `wall_color` in the Inspector. The ghost passes through both colors. Red walls let the knight pass; blue walls block the knight. Each wall changes to the opposite color when a switch is used, changing whether the knight can cross it.

Instance `scenes/wall_switch.tscn` where the switch should be. It swaps every `PhaseWall` in the current scene. Adjust `interaction_range`, `knight_can_use`, and `ghost_can_use` per switch. Add a level-specific visual or collision shape as needed; interaction uses distance, so no Area2D is required.

Instance `scenes/goal_tile.tscn` at the level exit. When the knight touches the yellow tiles, the win screen appears. The ghost does not trigger the goal.

The camera follows only `PlayerCharacter` and clamps its view to the used tile area. Set `Camera2D.bounds_path` to each level's `TileMapLayer` when switching or renaming levels. While the ghost is controlled, it is clamped inside the current camera view and passes through all level geometry. Adjust the camera zoom and ghost `camera_edge_margin` to tune the usable area for each room.
