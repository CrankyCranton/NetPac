class_name Enemy extends KinematicCharacter


func _ready() -> void:
	await room.ready
	room.navigation.set_point_solid(pos_to_id(position))


func take_turn(player_pos_id: Vector2i) -> void:
	var pos_id := pos_to_id(position)
	room.navigation.set_point_solid(pos_id, false)
	var path := room.navigation.get_id_path(pos_id, player_pos_id)

	if path.size() < 2 or not move(path[1] - pos_id):
		room.navigation.set_point_solid(pos_id)
	else:
		room.navigation.set_point_solid(path[1])
