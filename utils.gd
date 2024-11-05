class_name Utils extends Node


const TILE_SIZE := Vector2i.ONE * 16


static func pos2id(pos: Vector2) -> Vector2i:
	return Vector2i(pos.snapped(Vector2.ONE)) / TILE_SIZE


static func id2pos(id: Vector2i) -> Vector2:
	return Vector2(id * TILE_SIZE)
