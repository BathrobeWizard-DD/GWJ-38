extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 600.0
const RUN_ACCEL = 50
const RUN_SPEED_MAX = 300
const JUMP_SPEED = -300
var velocity = Vector2()

var isJumping
var isCrouching

var characterState 
onready var runningState = {"get_input": funcref(self,"running_input"), "ready_state": funcref(self, "ready_running")}
onready var crouchingState = {"get_input": funcref(self,"running_input"), "ready_state": funcref(self, "ready_crouching")}

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_state(runningState)

#*********Finite State Machine functions*****************
#Switch to a new state function
func switch_state(state):
	characterState = state
	character_function("ready_state")

#takes generic name of function as string.Call this every time you would call a funtion written here
func character_function(function):
	if characterState.has(function):
		characterState[function].call_func()

#same as before but with argument array
func character_function_args(function, argumentArray):
	if characterState.has(function):
		characterState[function].call_funcv(argumentArray)

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
	if moveLeft:
		directionHorizontal -= 1
#	moveLeftOrRight(directionHorizontal)

func _physics_process(delta):
	character_function("get_input")
	
	velocity.x = RUN_SPEED_MAX
	velocity.y += GRAVITY * delta
	if isJumping and is_on_floor():
		isJumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#*********STATE FUNCTIONS***************************

func ready_running():
	$defaultCollisionShape.set_disabled(false)
	$AnimatedSprite.set_animation("default")

func running_input():
#	velocity.x = 0
	var moveRight = Input.is_action_pressed("moveRight")
	var moveLeft = Input.is_action_pressed("moveLeft")
	var jumpUp = Input.is_action_just_pressed("jumpUp")
	
	if jumpUp and is_on_floor():
		isJumping = true
		velocity.y = JUMP_SPEED
	
	if Input.is_action_just_pressed("crouchDown"):
		switch_state(crouchingState)
	if Input.is_action_just_released("crouchDown"):
		switch_state(runningState)
	
	var directionHorizontal = 0
	if moveRight:
		directionHorizontal += 1
	if moveLeft:
		directionHorizontal -= 1
#	moveLeftOrRight(directionHorizontal)

func ready_crouching():
	$defaultCollisionShape.set_disabled(true)
	$AnimatedSprite.set_animation("crouch")

func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		body.position.x = 24
	if (body.position.y >= 360):
		body.position.y = 290
