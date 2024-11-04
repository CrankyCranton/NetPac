class_name Room extends TileMapLayer


var navigation := AStarGrid2D.new()

@onready var reference_rect: ReferenceRect = $ReferenceRect


func _ready() -> void:
	navigation.region = Rect2i(Vector2(), Vector2i(reference_rect.size) / tile_set.tile_size)
	navigation.cell_size = tile_set.tile_size
	navigation.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	navigation.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	navigation.update()
	for cell in get_used_cells():
		if not get_cell_tile_data(cell).get_custom_data("ID").contains("w"):
			navigation.set_point_solid(cell)


func take_turn(player_pos_id: Vector2i) -> void:
	for child in get_children():
		if child is Enemy:
			child.take_turn(player_pos_id)
