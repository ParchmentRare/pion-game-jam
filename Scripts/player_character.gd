class_name PlayerCharacter
extends CharacterBody2D


const SPEED = 150
const GRAVITY = 50
const JUMP_VELOCITY = -1000
 
func _physics_process(_delta: float) -> void:
	get_movement()
	
	
func get_movement():
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
		
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			velocity.y += JUMP_VELOCITY
	
	move_and_slide()
		
		
		
	
		
		

	
	
