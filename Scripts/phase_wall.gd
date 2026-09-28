extends StaticBody2D
class_name PhaseWall

enum WallColor { RED, BLUE }

const RED_LAYER_MASK := 1 << 2
const BLUE_LAYER_MASK := 1 << 1

signal color_changed(new_color: int)

@export var wall_color: WallColor = WallColor.RED
@export var wall_size := Vector2(32.0, 128.0)

var _collision_shape: CollisionShape2D
var _fill: Polygon2D
var _outline: Line2D

func _ready() -> void:
	add_to_group("phase_walls")
	_create_or_update_art_and_collision()
	_apply_wall_color()

func swap_color() -> void:
	wall_color = WallColor.BLUE if wall_color == WallColor.RED else WallColor.RED
	_apply_wall_color()
	color_changed.emit(wall_color)

func _create_or_update_art_and_collision() -> void:
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		add_child(_collision_shape)
	var rectangle := RectangleShape2D.new()
	rectangle.size = wall_size
	_collision_shape.shape = rectangle

	_fill = get_node_or_null("Fill") as Polygon2D
	if _fill == null:
		_fill = Polygon2D.new()
		_fill.name = "Fill"
		add_child(_fill)
	_fill.polygon = _rectangle_points(wall_size)
	_fill.z_index = 1

	_outline = get_node_or_null("Outline") as Line2D
	if _outline == null:
		_outline = Line2D.new()
		_outline.name = "Outline"
		add_child(_outline)
	_outline.points = PackedVector2Array([
			Vector2(-wall_size.x * 0.5, -wall_size.y * 0.5),
			Vector2(wall_size.x * 0.5, -wall_size.y * 0.5),
			Vector2(wall_size.x * 0.5, wall_size.y * 0.5),
			Vector2(-wall_size.x * 0.5, wall_size.y * 0.5),
			Vector2(-wall_size.x * 0.5, -wall_size.y * 0.5)
	])
	_outline.width = 2.0
	_outline.z_index = 2

func _apply_wall_color() -> void:
	if _collision_shape == null:
		return
	collision_layer = RED_LAYER_MASK if wall_color == WallColor.RED else BLUE_LAYER_MASK
	collision_mask = 0
	if _fill != null:
		_fill.color = Color("c54d62") if wall_color == WallColor.RED else Color("468bd2")
	if _outline != null:
		_outline.default_color = Color("ffacb8") if wall_color == WallColor.RED else Color("a6e1ff")

func _rectangle_points(size: Vector2) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-size.x * 0.5, -size.y * 0.5),
		Vector2(size.x * 0.5, -size.y * 0.5),
		Vector2(size.x * 0.5, size.y * 0.5),
		Vector2(-size.x * 0.5, size.y * 0.5)
	])
