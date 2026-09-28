extends CharacterBody2D

@export var move_speed := 200.0
@export var camera_edge_margin := Vector2(20.0, 20.0)
@export var platform_scene: PackedScene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var controlled := false
var has_spawned_platform := false

func _ready() -> void:
	add_to_group("ghost")
	collision_layer = 0
	# Ghosts pass through all level geometry, including both phase-wall colors.
	collision_mask = 0
	$CollisionShape2D.disabled = false
	var ghost_shape := $CollisionShape2D.shape as RectangleShape2D
	if ghost_shape != null:
		ghost_shape.size = Vector2(18.0, 20.0)
	$HitDetector.body_entered.connect(_on_hit_detector_body_entered)
	modulate = Color(0.65, 0.9, 1.0, 0.78)

func set_controlled(value: bool) -> void:
	controlled = value
	if not controlled:
		velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if not controlled:
		return
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	if velocity.x > 0.1:
		animated_sprite.flip_h = false
	elif velocity.x < -0.1:
		animated_sprite.flip_h = true
	animated_sprite.play("move" if velocity.length() > 1.0 else "default")
	move_and_slide()
	_clamp_to_camera_view()

func _clamp_to_camera_view() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var half_view := get_viewport_rect().size / (camera.zoom * 2.0) - camera_edge_margin
	var center := camera.get_screen_center_position()
	global_position.x = clampf(global_position.x, center.x - half_view.x, center.x + half_view.x)
	global_position.y = clampf(global_position.y, center.y - half_view.y, center.y + half_view.y)

func _on_hit_detector_body_entered(body: Node2D) -> void:
	if not body.is_in_group("platform_triggers") or has_spawned_platform or platform_scene == null:
		return
	has_spawned_platform = true
	var platform := platform_scene.instantiate() as Node2D
	if platform == null:
		return
	get_tree().current_scene.add_child(platform)
	platform.global_position = body.global_position + Vector2(0, 64)
