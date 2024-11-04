class_name Room extends TileMapLayer


var navigation := AStarGrid2D.new()
var children := {
	"enemies": [],
	"doors": [],
}

@onready var reference_rect: ReferenceRect = $ReferenceRect


func _ready() -> void:
	assert(tile_set.tile_size == Utils.TILE_SIZE)
	catagorize_children()
	set_up_navigation()


func catagorize_children() -> void:
	for child in get_children():
		if child is Enemy:
			children.enemies.append(child)
		elif child is Door:
			children.doors.append(child)


func set_up_navigation() -> void:
	navigation.region = Rect2i(Vector2(), Vector2i(reference_rect.size) / tile_set.tile_size)
	navigation.cell_size = tile_set.tile_size
	navigation.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	navigation.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	navigation.update()
	for cell in get_used_cells():
		if not get_tile_id(cell).contains("w"):
			navigation.set_point_solid(cell)


func take_turn(player_pos_id: Vector2i) -> void:
	for enemy: Enemy in children.enemies:
		enemy.take_turn(player_pos_id)


func get_tile_id(coords: Vector2i) -> StringName:
	var data := get_cell_tile_data(coords)
	if data:
		return data.get_custom_data("ID")
	else:
		return &""


func check_for_doors(player: Player) -> bool:
	for door: Door in children.doors:
		if Utils.pos2id(door.position) == Utils.pos2id(player.position) and door.outlet != null:
			var room := door.outlet.get_parent()
			position = room.position
			room.position = Vector2()

			player.reparent(room, false)
			player.position = door.outlet.position
			room.take_turn(Utils.pos2id(player.position))
			return true

	return false
