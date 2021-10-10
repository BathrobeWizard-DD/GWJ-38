extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 600.0
const RUN_ACCEL = 50
const RUN_SPEED_MAX = 300
const JUMP_SPEED = -300
var velocity = Vector2()

export var speed_modifier: float = 0.7

var isJumping
var isCrouching

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func moveLeftOrRight(directionMultiplier):
	velocity.x += directionMultiplier * (abs(velocity.x) + RUN_ACCEL)
	velocity.x = clamp(velocity.x, -RUN_SPEED_MAX, RUN_SPEED_MAX)

func get_input():
#	velocity.x = 0
	var moveRight = Input.is_action_pressed("moveRight")
	var moveLeft = Input.is_action_pressed("moveLeft")
	var jumpUp = Input.is_action_just_pressed("jumpUp")
	
	if jumpUp and is_on_floor():
		isJumping = true
		velocity.y = JUMP_SPEED
	
	isCrouching = Input.is_action_pressed("crouchDown")
	
	var directionHorizontal = 0
	if moveRight:
		directionHorizontal += 1
		$Fire.material.set_shader_param("speed", 2.0)
	else:
		$Fire.material.set_shader_param("speed", 0.5)
	if moveLeft:
		directionHorizontal -= 1
#	moveLeftOrRight(directionHorizontal)

func _physics_process(delta):
	get_input()
	
	if (isCrouching):
		$defaultCollisionShape.set_disabled(true)
		$AnimatedSprite.set_animation("crouch")
		velocity.x = RUN_SPEED_MAX * speed_modifier
	else:
		$defaultCollisionShape.set_disabled(false)
		$AnimatedSprite.set_animation("default")
		velocity.x = RUN_SPEED_MAX
		
	velocity.y += GRAVITY * delta
	if isJumping and is_on_floor():
		isJumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		body.position.x = 24
	if (body.position.y >= 360):
		body.position.y = 290
