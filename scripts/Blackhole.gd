extends Node2D

export var blackholeSize = 10
export var growthRate = 1.0
var innerCircleColor = Color( 1, 1, 1, 1)
var outerCircleColor = Color( 0, 0, 0, 1)
signal mainCharEntered()

func _ready():
	get_node("Area2D").position = position + Vector2(-20, -300)

func _draw():
	draw_circle(position + Vector2(-20, -300), min(blackholeSize * 1.1, blackholeSize + 20), innerCircleColor)
	draw_circle(position + Vector2(-20, -300), blackholeSize, outerCircleColor)

func _process(delta):
	blackholeSize += growthRate
	update()
	get_node("Area2D/CollisionShape2D").shape.radius = min(blackholeSize * 1.1, blackholeSize + 20)

func _on_Area2D_body_entered(body):
	if body.name == "mainChar":
		emit_signal("mainCharEntered")
