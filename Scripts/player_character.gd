class_name PlayerCharacter
extends CharacterBody2D

var PlayerGhost = preload("res://scenes/player_ghost.tscn")

const SPEED = 150
const GRAVITY = 38
const JUMP_VELOCITY = -800
const GHOST_SPAWN = Vector2(0, 15)

var spawned_character: CharacterBody2D = null
var can_control := true

@onready var _animated_sprite = $AnimatedSprite2D
 
func _physics_process(_delta: float) -> void:
	animate()
	if can_control:
		get_movement()
	
	
func get_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			velocity.y += JUMP_VELOCITY
	
	move_and_slide()
	
func animate():

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if not is_on_floor():
		_animated_sprite.play("jump")
	elif velocity.x != 0:
		_animated_sprite.play("walk")
	else:
		_animated_sprite.play("idle")

func _input(event):
	if event.is_action_pressed("spawn_character") and spawned_character == null:
		spawn_character()


func spawn_character():
	spawned_character = PlayerGhost.instantiate()

	# Add it to the same parent as the original player.
	get_parent().add_child(spawned_character)

	# Spawn it slightly to the right of the player.
	spawned_character.global_position = global_position + Vector2(64, 0)

	# Stop this character from responding to movement.
	can_control = false

	# Tell the spawned character when it should return control.
	spawned_character.character_removed.connect(_on_spawned_character_removed)


func _on_spawned_character_removed():
	spawned_character = null
	can_control = true
