@tool
class_name Door extends Sprite2D


@export var outlet: Door = null:
	set(value):
		if not is_node_ready():
			await ready
		outlet = value
		pen.destination = Vector2.INF
		if outlet:
			pen.destination = to_local(outlet.global_position)
			if not outlet.outlet:
				outlet.outlet = self
		pen.queue_redraw()

@onready var pen: Node2D = $Pen
