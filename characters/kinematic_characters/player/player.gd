class_name Player extends KinematicCharacter


signal gold_collected(max_room_gold: int, room_gold: int, total_gold: int)
signal died

var turn := 0:
	set(value):
		turn = value
		if turn % 2 == 0:
			room.take_turn(pos_id)
var frozen := false
var gold := {}

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await get_node("/root").ready
	update_gold_counter()


func _process(_delta: float) -> void:
	if frozen or tween != null:
		return

	var input := Vector2i(Input.get_vector(&"left", &"right", &"up", &"down"))
	if input == Vector2i.ZERO:
		return

	if room.navigation.is_in_boundsv(pos_id + input):
		if move(input):
			turn += 1
	elif room.check_for_doors(self):
		update_gold_counter()
		turn += 1
		#turn = 0
		frozen = true
		await get_tree().create_timer(ANIM_SPEED).timeout
		frozen = false


func reset() -> void:
	gold.erase(room)
	update_gold_counter()
	super()
	frozen = false


func count_gold() -> int:
	var total := 0
	for room_gold: int in gold.values():
		total += room_gold
	return total


func update_gold_counter() -> void:
	gold_collected.emit(room.max_gold, gold.get(room, 0), count_gold())


func die() -> void:
	frozen = true
	died.emit()
	animation_player.play(&"die")
	await animation_player.animation_finished


func _on_collided(with: StringName) -> void:
	if with.begins_with("Enemy"):
		room.get_node(NodePath(with)).flip_h = flip_h
		await die()
		room.reset()
	elif with.contains("coin"):
		gold[room] = gold.get_or_add(room, 0) + 1
		update_gold_counter()
		room.set_cell(pos_id)
