extends CharacterBody2D

signal character_removed

@export var move_speed := 200.0
@export var platform_scene: PackedScene

@onready var _animated_sprite := $AnimatedSprite2D

var has_spawned_platform := false


func _ready():
	$HitDetector.body_entered.connect(_on_hit_detector_body_entered)


func _physics_process(_delta):
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * move_speed
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if velocity.x != 0:
		_animated_sprite.play("move")	
	else:
		_animated_sprite.play("default")
	move_and_slide()


func _on_hit_detector_body_entered(body: Node2D):
	if not body.is_in_group("platform_triggers"):
		return

	if has_spawned_platform:
		return

	has_spawned_platform = true
	spawn_platform(body.global_position)


func spawn_platform(spawn_position: Vector2):
	var platform := platform_scene.instantiate()

	get_tree().current_scene.add_child(platform)

	platform.global_position = spawn_position + Vector2(0, 64)


func remove_character():
	character_removed.emit()
	queue_free()
