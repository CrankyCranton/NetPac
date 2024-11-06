class_name Room extends TileMapLayer


var navigation := AStarGrid2D.new()
var max_gold := 0
var children := {
	"enemies": [],
	"doors": [],
}

@onready var reference_rect: ReferenceRect = $ReferenceRect


func _ready() -> void:
	assert(tile_set.tile_size == Utils.TILE_SIZE)
	catagorize_children()

	navigation.region = Rect2i(Vector2(), Vector2i(reference_rect.size) / tile_set.tile_size)
	navigation.cell_size = tile_set.tile_size
	navigation.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	navigation.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	navigation.update()

	for cell in get_used_cells():
		var cell_id := get_tile_id(cell)
		if not cell_id.contains("w"):
			navigation.set_point_solid(cell)
		elif cell_id.contains("coin"):
			max_gold += 1


func catagorize_children() -> void:
	for child in get_children():
		if child is Enemy:
			children.enemies.append(child)
		elif child is Door:
			children.doors.append(child)


func take_turn(player_pos_id: Vector2i) -> void:
	for enemy: Enemy in children.enemies:
		enemy.take_turn(player_pos_id)


func get_tile_id(coords: Vector2i) -> StringName:
	var data := get_cell_tile_data(coords)
	if data:
		return data.get_custom_data("ID")
	else:
		return &"null"


func check_for_doors(player: Player) -> bool:
	for door: Door in children.doors:
		if Utils.pos2id(door.position) == Utils.pos2id(player.position) and door.outlet != null:
			var room := door.outlet.get_parent()
			position = room.position
			room.position = Vector2()

			player.reparent(room, false)
			player.position = door.outlet.position
			player.start_pos = player.position
			#room.take_turn(Utils.pos2id(player.position))
			return true

	return false


func check_collisions(id: Vector2i) -> Array[StringName]:
	var collisions: Array[StringName] = []
	var tile_id := get_tile_id(id)
	if tile_id != &"null":
		collisions.append(tile_id)

	for child in get_children():
		if child != reference_rect and Utils.pos2id(child.position) == id:
			collisions.append(child.name)

	return collisions


# Reset when the player dies.
# Reset enemies to position they were in from the start of the game.
# Reset the player to the position he was in when he entered the room.
func reset() -> void:
	if has_node(^"Player"):
		get_node(^"Player").reset()
	for enemy: Enemy in children.enemies:
		enemy.reset()
