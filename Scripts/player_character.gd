class_name PlayerCharacter
extends CharacterBody2D


const SPEED = 150
const GRAVITY = 50
const JUMP_VELOCITY = -1000

@onready var _animated_sprite = $AnimatedSprite2D
 
func _physics_process(_delta: float) -> void:
	animate()
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

	
		
		
		
	
		
		

	
	
