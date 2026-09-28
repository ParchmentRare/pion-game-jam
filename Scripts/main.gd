extends Node2D

const GHOST_SCENE: PackedScene = preload("res://scenes/player_ghost.tscn")
const WIN_SCREEN_SCENE: PackedScene = preload("res://scenes/win_screen.tscn")

@export var ghost_spawn_offset := Vector2(0, -4)

@onready var player: PlayerCharacter = $PlayerCharacter
@onready var camera: Camera2D = $Camera2D

var ghost: CharacterBody2D
var level_complete := false

func _ready() -> void:
	_setup_keyboard_input()
	_setup_gamepad_input()
	_build_controls_legend()
	add_to_group("level_managers")
	player.add_to_group("knight")
	player.set_controlled(true)
	camera.player_character = player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		get_tree().reload_current_scene()
		return
	if level_complete:
		return
	if event.is_action_pressed("spawn_character"):
		if not is_instance_valid(ghost):
			_spawn_ghost()
		return
	if event.is_action_pressed("dismiss_character") and is_instance_valid(ghost):
		_return_to_knight()
		return
	if event.is_action_pressed("interact"):
		_interact_with_nearest_switch()

func _spawn_ghost() -> void:
	ghost = GHOST_SCENE.instantiate() as CharacterBody2D
	ghost.global_position = player.global_position + ghost_spawn_offset
	get_tree().current_scene.add_child(ghost)
	ghost.tree_exiting.connect(_on_ghost_tree_exiting)
	player.set_controlled(false)
	ghost.set_controlled(true)

func _return_to_knight() -> void:
	if not is_instance_valid(ghost):
		return
	var returning_ghost := ghost
	ghost = null
	returning_ghost.set_controlled(false)
	returning_ghost.queue_free()
	player.set_controlled(true)

func _on_ghost_tree_exiting() -> void:
	if is_instance_valid(ghost):
		ghost = null
		player.set_controlled(true)

func _interact_with_nearest_switch() -> void:
	var actor: Node2D = ghost if is_instance_valid(ghost) else player
	var nearest: Node2D
	var nearest_distance := INF
	for candidate in get_tree().get_nodes_in_group("wall_switches"):
		var switch_node := candidate as Node2D
		if switch_node == null or not switch_node.has_method("can_interact") or not switch_node.has_method("interact"):
			continue
		if not switch_node.call("can_interact", actor):
			continue
		var distance := actor.global_position.distance_to(switch_node.global_position)
		if distance < nearest_distance:
			nearest = switch_node
			nearest_distance = distance
	if is_instance_valid(nearest):
		nearest.call("interact", actor)

func show_win_screen() -> void:
	if level_complete:
		return
	level_complete = true
	player.set_controlled(false)
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)
	if is_instance_valid(ghost):
		ghost.set_controlled(false)
		ghost.queue_free()
		ghost = null
	var layer := CanvasLayer.new()
	layer.name = "WinScreenLayer"
	layer.layer = 10
	add_child(layer)
	var win_screen := WIN_SCREEN_SCENE.instantiate() as Control
	layer.add_child(win_screen)
	win_screen.connect("restart_requested", _restart_current_scene)

func _restart_current_scene() -> void:
	get_tree().reload_current_scene()

func _setup_keyboard_input() -> void:
	_add_key("move_left", KEY_A)
	_add_key("move_left", KEY_LEFT)
	_add_key("move_right", KEY_D)
	_add_key("move_right", KEY_RIGHT)
	_add_key("move_up", KEY_W)
	_add_key("move_up", KEY_UP)
	_add_key("move_down", KEY_S)
	_add_key("move_down", KEY_DOWN)
	_add_key("jump", KEY_SPACE)
	_add_key("spawn_character", KEY_E)
	_add_key("dismiss_character", KEY_Q)
	_add_key("interact", KEY_F)
	_add_key("restart_level", KEY_R)

func _setup_gamepad_input() -> void:
	_add_joypad_button("interact", JOY_BUTTON_RIGHT_SHOULDER)
	_add_joypad_button("restart_level", JOY_BUTTON_START)

func _add_key(action: StringName, key: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var key_event := InputEventKey.new()
	key_event.physical_keycode = key
	if not InputMap.action_has_event(action, key_event):
		InputMap.action_add_event(action, key_event)

func _add_joypad_button(action: StringName, button: JoyButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var button_event := InputEventJoypadButton.new()
	button_event.button_index = button
	if not InputMap.action_has_event(action, button_event):
		InputMap.action_add_event(action, button_event)

func _build_controls_legend() -> void:
	var layer := CanvasLayer.new()
	layer.name = "ControlsLegend"
	add_child(layer)
	var background := ColorRect.new()
	background.name = "Background"
	background.anchor_left = 0.0
	background.anchor_right = 1.0
	background.anchor_top = 1.0
	background.anchor_bottom = 1.0
	background.offset_top = -44.0
	background.color = Color(0.025, 0.035, 0.07, 0.78)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(background)
	var controls := Label.new()
	controls.name = "Controls"
	controls.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	controls.position = Vector2(12, -40)
	controls.text = "PC: A/D or ←/→ Move • Space Jump • E Ghost • Q Return • F Switch • R Restart\nXBOX: Left Stick / D-pad Move • A Jump • X Ghost • Y Return • RB Switch • Menu Restart"
	controls.add_theme_font_size_override("font_size", 11)
	controls.add_theme_color_override("font_color", Color("e4eaff"))
	controls.add_theme_color_override("font_outline_color", Color("101521"))
	controls.add_theme_constant_override("outline_size", 2)
	controls.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(controls)
