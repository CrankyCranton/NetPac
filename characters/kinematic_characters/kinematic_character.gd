class_name KinematicCharacter extends Sprite2D


const ANIM_SPEED := 0.25

var tween: Tween = null

@onready var room: Room = null:
	set(_value):
		pass
	get:
		return get_parent()


func move(direction: Vector2i) -> bool:
	var destination := position.snapped(Utils.TILE_SIZE) + Vector2(direction * Utils.TILE_SIZE)
	if room.navigation.is_point_solid(Utils.pos2id(destination)):
		return false
	if tween != null:
		tween.stop()
		tween = null
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, ^"position", destination, ANIM_SPEED)
	tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)
	return true


func _on_tween_finished() -> void:
	tween = null
