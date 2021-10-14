extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var initPos: Vector2
export var destPos: Vector2
export var speedFactor = 3
var framesCount = 0

func _physics_process(delta):
	framesCount += (delta * speedFactor)
	framesCount = fmod(framesCount, TAU)
	var finalInterpolateValue = ((-cos(framesCount)) + 1) / 2
	position = initPos.linear_interpolate(destPos, finalInterpolateValue)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
