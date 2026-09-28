extends Node2D
class_name WallSwitch

signal switched(is_active: bool)

@export var interaction_range := 56.0
@export var knight_can_use := true
@export var ghost_can_use := true
@export var cooldown := 0.25

var is_active := false
var _last_used_msec := -1000
var _rune: Polygon2D
var _ring: Line2D

func _ready() -> void:
	add_to_group("wall_switches")
	_create_visuals()

func can_interact(actor: Node2D) -> bool:
	if not is_instance_valid(actor) or global_position.distance_to(actor.global_position) > interaction_range:
		return false
	if actor.is_in_group("ghost"):
		return ghost_can_use
	if actor.is_in_group("knight"):
		return knight_can_use
	return false

func interact(actor: Node2D) -> bool:
	var now := Time.get_ticks_msec()
	if not can_interact(actor) or now - _last_used_msec < int(cooldown * 1000.0):
		return false
	_last_used_msec = now
	for wall in get_tree().get_nodes_in_group("phase_walls"):
		if wall.has_method("swap_color"):
			wall.call("swap_color")
	var next_state := not is_active
	for switch_node in get_tree().get_nodes_in_group("wall_switches"):
		if switch_node.has_method("set_active_state"):
			switch_node.call("set_active_state", next_state)
	switched.emit(is_active)
	return true

func set_active_state(active: bool) -> void:
	is_active = active
	_update_visuals()

func _create_visuals() -> void:
	_rune = Polygon2D.new()
	_rune.name = "SwitchRune"
	_rune.polygon = PackedVector2Array([
		Vector2(0, -12), Vector2(10, -2), Vector2(6, 10),
		Vector2(-6, 10), Vector2(-10, -2)
	])
	_rune.color = Color("73d7ef")
	_rune.z_index = 2
	add_child(_rune)

	_ring = Line2D.new()
	_ring.name = "SwitchRing"
	for point_index in range(17):
		var angle := TAU * float(point_index) / 16.0
		_ring.add_point(Vector2(cos(angle), sin(angle)) * 17.0)
	_ring.width = 2.0
	_ring.default_color = Color("b7f6ff")
	_ring.z_index = 1
	add_child(_ring)

func _update_visuals() -> void:
	_rune.color = Color("ffca70") if is_active else Color("73d7ef")
	_ring.default_color = Color("ffe2a9") if is_active else Color("b7f6ff")
