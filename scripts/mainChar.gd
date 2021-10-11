extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 600.0
const RUN_ACCEL = 50
const RUN_SPEED_MAX = 300
const JUMP_SPEED = -300
var velocity = Vector2()

#var isJumping
#var isCrouching

var characterState 
onready var runningState = {"get_input": funcref(self,"input_running"), "ready_state": funcref(self, "ready_running"),
							 "process_state": funcref(self, "process_running"), "get_state": funcref(self, "state_running")}
onready var crouchingState = {"get_input": funcref(self,"input_jumping"), "ready_state": funcref(self, "ready_crouching"),
							 "process_state": funcref(self, "process_crouching"), "get_state": funcref(self, "state_crouching")}
onready var jumpingState = {"get_input": funcref(self,"input_jumping"), "ready_state": funcref(self, "ready_jumping"),
							 "process_state": funcref(self, "process_jumping"), "get_state": funcref(self, "state_jumping")}
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

func _input(event):
	character_function_args("get_input", [event])

func _physics_process(delta):
	character_function("process_state")
	
	velocity.x = RUN_SPEED_MAX
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#*********STATE FUNCTIONS***************************

func ready_running():
	$defaultCollisionShape.set_disabled(false)
	$AnimatedSprite.set_animation("default")

func ready_crouching():
	$defaultCollisionShape.set_disabled(true)
	$AnimatedSprite.set_animation("crouch")

func ready_jumping():
	self.position.y -= 2
	velocity.y = JUMP_SPEED

func process_running():
	pass

func process_crouching():
	pass

func process_jumping():
	if is_on_floor():
		switch_state(runningState)

func state_running():
	return "running"

func state_crouching():
	return "crouching"

func state_jumping():
	return "jumping"

func input_running(event):
#	velocity.x = 0
	var moveRight = event.is_action_pressed("moveRight")
	var moveLeft = event.is_action_pressed("moveLeft")
	if event.is_action_pressed("jumpUp") && is_on_floor():
		switch_state(jumpingState)
	if event.is_action_pressed("crouchDown"):
		switch_state(crouchingState)
	if event.is_action_released("crouchDown"):
		switch_state(runningState)
	
	var directionHorizontal = 0
	if moveRight:
		directionHorizontal += 1
	if moveLeft:
		directionHorizontal -= 1
#	moveLeftOrRight(directionHorizontal)

func input_jumping(event):
	var moveRight = event.is_action_pressed("moveRight")
	var moveLeft = event.is_action_pressed("moveLeft")
	
	if event.is_action_pressed("crouchDown"):
		switch_state(crouchingState)
	if event.is_action_released("crouchDown"):
		switch_state(runningState)
	
	var directionHorizontal = 0
	if moveRight:
		directionHorizontal += 1
	if moveLeft:
		directionHorizontal -= 1
#	moveLeftOrRight(directionHorizontal)

func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		body.position.x = 24
	if (body.position.y >= 360):
		body.position.y = 290
