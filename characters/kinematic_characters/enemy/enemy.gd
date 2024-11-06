class_name Enemy extends KinematicCharacter


@export var damage := 10


func _ready() -> void:
	await room.ready
	room.navigation.set_point_solid(Utils.pos2id(position))


func reset() -> void:
	room.navigation.set_point_solid(pos_id, false)
	super()
	room.navigation.set_point_solid(pos_id)


func take_turn(player_pos_id: Vector2i) -> void:
	room.navigation.set_point_solid(pos_id, false)
	var path := room.navigation.get_id_path(pos_id, player_pos_id)

	if path.size() < 2 or not move(path[1] - pos_id):
		room.navigation.set_point_solid(pos_id)
	else:
		room.navigation.set_point_solid(path[1])


func _on_collided(with: StringName) -> void:
	if with == &"Player":
		room.get_node(NodePath(with)).die(damage)
