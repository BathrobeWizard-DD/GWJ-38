extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 600.0
const RUN_ACCEL = 15
const INAIR_ACCEL = 2.5
const RUN_SPEED_MIN = 130
const RUN_SPEED_MAX = 270
const REGULAR_JUMP_SPEED = -300
const FROM_CROUCH_JUMP_SPEED = -475
const MAX_CHARGE_SPEED = 75

var velocity := Vector2()
var currentRunSpeed = (RUN_SPEED_MIN + RUN_SPEED_MAX) / 2
var currentJumpSpeed = REGULAR_JUMP_SPEED
var chargeVelocity = 0

var left_key_pressed = false
var right_key_pressed = false
var up_key_pressed = false
var down_key_pressed = false
#var isJumping
#var isCrouching
var characterState

onready var charTween = get_node("mainCharTween") as Tween
onready var sprite = get_node("PlayerSprite") as PlayerSprite

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
onready var chargingState = {
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

func _input(event):
	input_tracker(event)
	character_function_args("get_input", [event])

func input_tracker(event):
	if event is InputEventKey:
		if event.is_action_pressed("moveLeft"):
			left_key_pressed = true
		elif event.is_action_pressed("moveRight"):
			right_key_pressed = true
		elif event.is_action_pressed("crouchDown"):
			down_key_pressed = true
		elif event.is_action_released("moveLeft"):
			left_key_pressed = false
		elif event.is_action_released("moveRight"):
			right_key_pressed = false
		elif event.is_action_released("crouchDown"):
			down_key_pressed = false

func _physics_process(delta):
	character_function("process_state")
	
	velocity.x = currentRunSpeed
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	#print(character_function("get_state"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#*********STATE FUNCTIONS***************************

func ready_running():
	$defaultCollisionShape.set_disabled(false)

func ready_crouching():
	$defaultCollisionShape.set_disabled(true)
	sprite.crouch()
	charTween.interpolate_property(self,"currentJumpSpeed",REGULAR_JUMP_SPEED, FROM_CROUCH_JUMP_SPEED, 0.5, Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	charTween.start()

func ready_jumping():
	sprite.jump()

func ready_charging():
	sprite.charge()
	charTween.interpolate_property(self, "chargeVelocity", 0, MAX_CHARGE_SPEED, 1.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	charTween.start()

func process_running():
	sprite.skate(velocity.x, RUN_SPEED_MAX, RUN_SPEED_MIN)
	input_left_right_acceleration_check()
	if not is_on_floor():
		switch_state(jumpingState)

func process_crouching():
	pass

func process_jumping():
	sprite.jump(velocity.y)

	input_left_right_acceleration_check()
	if is_on_floor():
		sprite.land()
		return switch_state(runningState)

func process_charging():
	#print(chargeVelocity)
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
	input_jumping_from_crouching_check(event)
	if event.is_action_released("crouchDown"):
		switch_state(runningState)

func input_running(event):
	input_jumping_from_running_check(event)
	input_crouching_check(event)
	input_charging_check(event)

func input_jumping(event):
	input_crouching_check(event)

func input_charging(event):
	input_charging_release_check(event)

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

func input_jumping_from_running_check(event):
	if event.is_action_pressed("jumpUp") && is_on_floor():
		currentJumpSpeed = REGULAR_JUMP_SPEED
		self.position.y -= 2
		velocity.y = currentJumpSpeed
		switch_state(jumpingState)

func input_charging_check(event):
	if left_key_pressed && right_key_pressed && event is InputEventKey:
		if event.is_echo():
			switch_state(chargingState)

func input_charging_release_check(event):
	if !left_key_pressed || !right_key_pressed:
		charTween.stop(self, "chargeVelocity")
		charTween.interpolate_property(self, "currentRunSpeed", currentRunSpeed, currentRunSpeed + chargeVelocity, 1.0,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		charTween.start()
		switch_state(runningState)

func input_jumping_from_crouching_check(event):
	if event.is_action("jumpUp") && is_on_floor():
		charTween.stop(self, "currentJumpSpeed")
		self.position.y -= 2
		velocity.y = currentJumpSpeed
		switch_state(jumpingState)

func charging_deaccelerate():
	pass

func charging_boost():
	pass

func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		body.position.x = 24
	if (body.position.y >= 360):
		body.position.y = 290
