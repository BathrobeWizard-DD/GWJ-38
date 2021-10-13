extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 600.0
const RUN_ACCEL = 10
const INAIR_ACCEL = 2.5
const RUN_SPEED_MIN = 230
const RUN_SPEED_MAX = 370
const REGULAR_JUMP_SPEED = -300
const FROM_CROUCH_JUMP_SPEED = -400
const MAX_SPRINT_SPEED = 420

var velocity = Vector2()
var currentRunSpeed = (RUN_SPEED_MIN + RUN_SPEED_MAX) / 2
var currentJumpSpeed = REGULAR_JUMP_SPEED

#var isJumping
#var isCrouching

var characterState 
onready var runningState = {
	"get_input": funcref(self,"input_running"),
	"ready_state": funcref(self, "ready_running"),
	"process_state": funcref(self, "process_running"),
	"get_state": funcref(self, "state_running")
}
onready var crouchingState = {
	"get_input": funcref(self,"input_crouching"),
	"ready_state": funcref(self, "ready_crouching"),
	"process_state": funcref(self, "process_crouching"),
	"get_state": funcref(self, "state_crouching")
}
onready var jumpingState = {
	"get_input": funcref(self,"input_jumping"),
	"ready_state": funcref(self, "ready_jumping"),
	"process_state": funcref(self, "process_jumping"),
	"get_state": funcref(self, "state_jumping")
}
onready var chargeState = {
	"get_input": funcref(self,"input_charging"),
	"ready_state": funcref(self, "ready_charging"),
	"process_state": funcref(self, "process_charging"),
	"get_state": funcref(self, "state_charging")
}

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
		return characterState[function].call_func()

#same as before but with argument array
func character_function_args(function, argumentArray):
	if characterState.has(function):
		characterState[function].call_funcv(argumentArray)

func speedUpOrSlowDown(directionMultiplier, speedDelta = RUN_ACCEL):
	currentRunSpeed = clamp(
		currentRunSpeed + (directionMultiplier * speedDelta),
		RUN_SPEED_MIN, RUN_SPEED_MAX
	)
	print(currentRunSpeed)

func _input(event):
	character_function_args("get_input", [event])

func _physics_process(delta):
	character_function("process_state")
	
	velocity.x = currentRunSpeed
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	print(character_function("get_state"))

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
	pass

func ready_charging():
	pass

func process_running():
	input_left_right_acceleration_check()
	if not is_on_floor():
		switch_state(jumpingState)

func process_crouching():
	pass

func process_jumping():
	input_left_right_acceleration_check()
	if is_on_floor():
		return switch_state(runningState)

func process_charging():
	pass

func state_running():
	return str("running")

func state_crouching():
	return str("crouching")

func state_jumping():
	return str("jumping")

func state_charging():
	return str("charging")

func input_crouching(event):
	input_jumping_check(event)
	if event.is_action_released("crouchDown"):
		switch_state(runningState)

func input_running(event):
	input_jumping_check(event)
	input_crouching_check(event)

func input_jumping(event):
	input_crouching_check(event)

func input_charging(event):
	pass

func input_left_right_acceleration_check():
	var moveRight = Input.is_action_pressed("moveRight")
	var moveLeft = Input.is_action_pressed("moveLeft")
	var directionHorizontal = 0
	
	if moveRight:
		directionHorizontal += 1
	if moveLeft:
		directionHorizontal -= 1
	if (directionHorizontal != 0):
		speedUpOrSlowDown(directionHorizontal, INAIR_ACCEL)

func input_crouching_check(event):
	if event.is_action_pressed("crouchDown"):
		switch_state(crouchingState)
	if event.is_action_released("crouchDown"):
		switch_state(runningState)

func input_jumping_check(event):
	if event.is_action_pressed("jumpUp") && is_on_floor():
		currentJumpSpeed = REGULAR_JUMP_SPEED
		self.position.y -= 2
		velocity.y = currentJumpSpeed
		switch_state(jumpingState)

func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		body.position.x = 24
	if (body.position.y >= 360):
		body.position.y = 290
