class_name Utils extends Node


const TILE_SIZE := Vector2i.ONE * 16


static func pos2id(pos: Vector2) -> Vector2i:
	return Vector2i(pos) / TILE_SIZE
