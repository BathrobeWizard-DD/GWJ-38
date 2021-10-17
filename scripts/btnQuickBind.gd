extends Button

export(int, "WASD", "Arrow Keys") var quickRebindType

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	match quickRebindType:
		0:
			set_text("WASD")
		1:
			set_text("Arrow Keys")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateAction(inputAction, input_event):
	InputMap.action_erase_events(inputAction)
	InputMap.action_add_event(inputAction, input_event)
	_update_button_text(input_event)

func _update_button_text(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton:
		if input_event.button_index == BUTTON_LEFT:
			text = "Mouse Left"
		elif input_event.button_index == BUTTON_RIGHT:
			text = "Mouse Right"
		elif input_event.button_index == BUTTON_MIDDLE:
			text = "Mouse Middle"
	else:
		text = input_event.as_text()

func _on_quickBind_pressed():
	ButtonPress.play()
	var moveLeftInputKey = InputEventKey.new()
	var moveRightInputKey = InputEventKey.new()
	var crouchDownInputKey = InputEventKey.new()
	
	match quickRebindType:
		0:
			moveLeftInputKey.scancode = KEY_A
			moveRightInputKey.scancode = KEY_D
			crouchDownInputKey.scancode = KEY_S
		1:
			moveLeftInputKey.scancode = KEY_LEFT
			moveRightInputKey.scancode = KEY_RIGHT
			crouchDownInputKey.scancode = KEY_DOWN

	get_node("../GridContainer/slowDown/rebindableAction").updateAction('moveLeft', moveLeftInputKey)
	get_node("../GridContainer/speedUp/rebindableAction").updateAction('moveRight', moveRightInputKey)
	get_node("../GridContainer/crouchDown/rebindableAction").updateAction('crouchDown', crouchDownInputKey)
