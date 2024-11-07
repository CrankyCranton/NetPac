class_name Player extends KinematicCharacter


signal gold_collected(max_room_gold: int, room_gold: int, total_gold: int)
signal damaged(gold: int)

var turn := 0:
	set(value):
		turn = value
		if turn % 2 == 0:
			room.take_turn(pos_id)
var frozen := false
var gold := {}
var dead := false

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
		#turn += 1
		turn = 0
		frozen = true
		await get_tree().create_timer(ANIM_SPEED).timeout
		frozen = false


func reset() -> void:
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


func die(damage: int) -> void:
	if dead:
		return
	dead = true

	gold[room] = max(0, gold.get_or_add(room, 0) - damage)
	damaged.emit(gold[room])
	frozen = true
	animation_player.play(&"die")
	await animation_player.animation_finished
	room.reset()
	dead = false


func _on_collided(with: StringName) -> void:
	if with.begins_with("Enemy"):
		var enemy: Enemy = room.get_node(NodePath(with))
		enemy.flip_h = flip_h
		die(enemy.damage)

	var value := room.get_tile_value(with)
	if value > 0:
		gold[room] = gold.get_or_add(room, 0) + value
		update_gold_counter()
		room.set_cell(pos_id)
