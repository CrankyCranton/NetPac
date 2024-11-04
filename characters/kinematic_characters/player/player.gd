class_name Player extends KinematicCharacter


var turn := 0
var frozen := false
var total_gold := 0
var room_gold := 0:
	set(value):
		room_gold = value
		$Label.text = str(room_gold)


func _process(_delta: float) -> void:
	if frozen or tween != null:
		return

	var input := Vector2i(Input.get_vector(&"left", &"right", &"up", &"down"))
	var pos_id := Utils.pos2id(position)
	if input == Vector2i.ZERO:
		return
	if room.navigation.is_in_boundsv(pos_id + input):
		if move(input):
			var destination := pos_id + input
			if room.get_tile_id(destination).contains("coin"):
				room.set_cell(destination)
				room_gold += 1
			turn += 1
			if turn % 2 == 0:
				room.take_turn(destination)
	elif room.check_for_doors(self):
		total_gold += room_gold
		room_gold = 0
		turn = 0
		frozen = true
		await get_tree().create_timer(ANIM_SPEED).timeout
		frozen = false
