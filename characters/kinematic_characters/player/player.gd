class_name Player extends KinematicCharacter


var turn := 0


func _process(_delta: float) -> void:
	var input := Vector2i(Input.get_vector(&"left", &"right", &"up", &"down"))
	var pos_id := pos_to_id(position)
	if room.navigation.is_in_boundsv(pos_id + input):
		if input != Vector2i.ZERO and tween == null and move(input):
			turn += 1
			$Label.text = str(turn)
			if turn % 2 == 0:
				room.take_turn(pos_id + input)
