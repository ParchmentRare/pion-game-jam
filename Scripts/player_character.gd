extends CharacterBody2D
class_name PlayerCharacter

const BLUE_WALL_LAYER_MASK := 1 << 1

@export var move_speed := 150.0
@export var gravity := 1200.0
@export var jump_velocity := -420.0

var can_control := true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("knight")
	collision_layer = 1
	collision_mask = 1 | BLUE_WALL_LAYER_MASK

func set_controlled(value: bool) -> void:
	can_control = value
	if not value:
		velocity.x = 0.0

func _physics_process(delta: float) -> void:
	if can_control:
		var direction := Input.get_axis("move_left", "move_right")
		velocity.x = direction * move_speed
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)

	if not is_on_floor():
		velocity.y += gravity * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0

	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if velocity.x > 0.1:
		animated_sprite.flip_h = false
	elif velocity.x < -0.1:
		animated_sprite.flip_h = true
	if not is_on_floor():
		animated_sprite.play("jump")
	elif absf(velocity.x) > 1.0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
