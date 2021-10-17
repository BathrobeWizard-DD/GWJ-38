extends Node2D

export var blackholeSize = 10
export(float) var growthRate = 1.0
export(Color) var innerCircleColor = Color( 1, 1, 1, 1)
export(Color) var outerCircleColor = Color( 0, 0, 0, 1)

signal mainCharEntered()

func _ready():
	get_node("Sprite").material.set_shader_param("center", Vector2())

func _draw():
	draw_circle(to_local(global_position), min(blackholeSize * 1.1, blackholeSize + 20), innerCircleColor)
	draw_circle(to_local(global_position), blackholeSize, outerCircleColor)

func _process(delta):
	blackholeSize += growthRate + delta
	get_node("Sprite").material.set_shader_param("size", blackholeSize / 360)
	update()
	get_node("Area2D/CollisionShape2D").shape.radius = min(blackholeSize * 1.1, blackholeSize + 20)

func _on_Area2D_body_entered(body):
	if body.name == "mainChar":
		emit_signal("mainCharEntered")
