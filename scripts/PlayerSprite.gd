class_name PlayerSprite extends Sprite

export(int) var start_apex_velocity = -50.0
export(int) var end_apex_velocity = 50.0

onready var player = get_node("AnimationPlayer") as AnimationPlayer

var is_jumping := false
var is_falling = false

var old_y_vel := 0.0

func skate(current_speed: int, max_speed, min_speed):
	is_falling = false
	is_jumping = false
	if player.current_animation != "Land":
		player.playback_speed = range_lerp(current_speed, max_speed, min_speed, 2, 0.75)
		player.play("Skate")


func crouch():
	is_falling = false
	is_jumping = false
	player.play("Crouch")


func jump(y_vel: float=0.0):
	if y_vel < end_apex_velocity and y_vel > start_apex_velocity:
		#print("apex")
		player.play("Apex")
	elif y_vel <= start_apex_velocity and !is_jumping:
		#print("rising")
		is_jumping = true
		player.play("Jump")
	elif y_vel >= end_apex_velocity and !is_falling:
		is_falling = true
		#print("falling")
		player.play("Fall")
		

func charge():
	is_falling = false
	is_jumping = false
	player.play("Charge")

func land():
	player.play("Land")
