class_name KinematicCharacter extends Sprite2D


signal collided(with: StringName)

const ANIM_SPEED := 0.25

var tween: Tween = null

@onready var start_pos := position
@onready var room: Room = null:
	set(value):
		assert(false, "Attempted to set read-only variable \"room\" to " + str(value))
	get:
		return get_parent()
# Might not work with +=, -=, *=, etc...
@onready var pos_id := Utils.pos2id(position):
	set(value):
		pos_id = value
		position = Utils.id2pos(pos_id)
	get:
		return Utils.pos2id(position)


func move(direction: Vector2i) -> bool:
	var destination := pos_id + direction
	var tile_id := room.get_tile_id(destination)

	if tile_id != &"null" and not tile_id.contains("w"):
		return false
	var colliders := room.check_collisions(destination)

	set_pos_with_anim(Utils.id2pos(destination))
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

	for collider in colliders:
		collided.emit(collider)
	return true


func set_pos_with_anim(pos: Vector2, trans := Tween.TRANS_SPRING) -> void:
	var last_pos := position
	position = pos
	offset = last_pos - position

	stop_tween()
	tween = create_tween()
	tween.set_trans(trans).tween_property(self, ^"offset", Vector2.ZERO, ANIM_SPEED)
	tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)


func stop_tween() -> void:
	if tween != null:
		tween.stop()
		tween = null


func reset() -> void:
	set_pos_with_anim(start_pos)


func _on_tween_finished() -> void:
	tween = null
