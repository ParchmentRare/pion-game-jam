extends Area2D
class_name GoalTile

signal reached(actor: Node2D)

@export_range(1, 12, 1) var columns := 4
@export_range(1, 8, 1) var rows := 2
@export var tile_size := Vector2(16.0, 16.0)
@export var tile_gap := 2.0

var _triggered := false

func _ready() -> void:
	add_to_group("goal_tiles")
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	_build_tiles()
	_build_trigger()
	body_entered.connect(_on_body_entered)

func _build_tiles() -> void:
	var palette := [Color("ffe16b"), Color("ffc84a"), Color("ffdb60"), Color("f7b938")]
	var total_size := Vector2(columns, rows) * tile_size + Vector2(maxi(0, columns - 1), maxi(0, rows - 1)) * tile_gap
	var start := -total_size * 0.5 + tile_size * 0.5
	for row in range(rows):
		for column in range(columns):
			var tile := Polygon2D.new()
			tile.position = start + Vector2(column, row) * (tile_size + Vector2.ONE * tile_gap)
			tile.polygon = PackedVector2Array([
				Vector2(-tile_size.x * 0.5, -tile_size.y * 0.5),
				Vector2(tile_size.x * 0.5, -tile_size.y * 0.5),
				Vector2(tile_size.x * 0.5, tile_size.y * 0.5),
				Vector2(-tile_size.x * 0.5, tile_size.y * 0.5)
			])
			tile.color = palette[(row * columns + column) % palette.size()]
			tile.z_index = 4
			add_child(tile)

func _build_trigger() -> void:
	var shape_node := CollisionShape2D.new()
	shape_node.name = "GoalTrigger"
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(columns, rows) * tile_size + Vector2(maxi(0, columns - 1), maxi(0, rows - 1)) * tile_gap
	shape_node.shape = rectangle
	add_child(shape_node)

func _on_body_entered(body: Node2D) -> void:
	if _triggered or not body.is_in_group("knight"):
		return
	_triggered = true
	reached.emit(body)
	get_tree().call_group("level_managers", "show_win_screen")
