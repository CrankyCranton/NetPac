class_name KinematicCharacter extends Sprite2D


const ANIM_SPEED := 0.25

var tween: Tween = null

@onready var room: Room = get_parent()
@onready var tile_size := room.tile_set.tile_size


func move(direction: Vector2i) -> bool:
	var destination := position.snapped(tile_size) + Vector2(direction * tile_size)
	if room.navigation.is_point_solid(Vector2i(destination) / tile_size):
		return false
	if tween != null:
		tween.stop()
		tween = null
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, ^"position", destination, ANIM_SPEED)
	tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)
	return true


func pos_to_id(pos: Vector2) -> Vector2i:
	return Vector2i(pos) / tile_size


func _on_tween_finished() -> void:
	tween = null
