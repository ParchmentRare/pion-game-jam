extends Camera2D

@export var player_character: PlayerCharacter

var __target_pos: Vector2

func _process(delta: float) -> void:
	__target_pos = lerp(__target_pos, player_character.global_position, 30.0 * delta)
	self.global_position = __target_pos
