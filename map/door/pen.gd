@tool
extends Node2D


var destination := Vector2.INF


func _draw() -> void:
	if destination != Vector2.INF and Engine.is_editor_hint():
		const COLOR := Color(1.0, 0.0, 0.0, 0.5)
		var outlet_pos := destination + Vector2(Utils.TILE_SIZE) / 2.0
		draw_dashed_line(Utils.TILE_SIZE / 2, outlet_pos, COLOR, 1.0)
		draw_circle(outlet_pos, 2.0, COLOR, false, 2.0)
