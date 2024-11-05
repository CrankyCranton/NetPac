class_name HUD extends CanvasLayer


@onready var gold_bar_damage: ProgressBar = %GoldBarDamage
@onready var room_gold_bar: ProgressBar = %RoomGoldBar
@onready var room_gold_counter: Label = %RoomGoldCounter
@onready var total_gold_counter: Label = %TotalGoldCounter


func reset() -> void:
	gold_bar_damage.value = room_gold_bar.value
	create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN
			).tween_property(gold_bar_damage, ^"value", 0, 0.5)
	room_gold_bar.value = 0


func set_gold(max_room_gold: int, room_gold: int, total_gold: int, damage_anim := false) -> void:
	gold_bar_damage.max_value = max_room_gold
	room_gold_bar.max_value = max_room_gold
	room_gold_bar.value = room_gold
	room_gold_counter.text = "$ " + str(room_gold) + "/" + str(max_room_gold)
	total_gold_counter.text = "Total: $" + str(total_gold)


func set_max_room_gold(max_room_gold: int) -> void:
	room_gold_bar.max_value = max_room_gold
