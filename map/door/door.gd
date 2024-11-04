class_name Door extends Sprite2D


enum Sprites {
	OPEN_DOOR,
	CLOSED_DOOR,
	STAIRS_UP,
	STAIRS_DOWN,
}

const REGION_RECTS: Array[Rect2] = [

]

@export var sprite := Sprites.OPEN_DOOR:
	set(value):
		sprite = value
		region_rect = REGION_RECTS[value]
