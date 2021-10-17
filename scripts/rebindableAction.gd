extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Set this string to the name of the action in the InputMap
export(String) var action

var _editing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var actionList = InputMap.get_action_list(action)
	if actionList.size() > 0:
		_update_button_text(actionList[0])

func updateAction(inputAction, input_event):
	InputMap.action_erase_events(inputAction)
	InputMap.action_add_event(inputAction, input_event)
	_update_button_text(input_event)

func _input(input_event: InputEvent) -> void:
	if _editing:
		if (input_event is InputEventMouseMotion):
			return
			
		if (input_event.as_text() != "Escape"):
			updateAction(action, input_event)
			_editing = false
			pressed = false
			
	#		$ActiveSound.play()
		else:
			_editing = false
			pressed = false

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_rebindableAction_pressed() -> void:
	_editing = true
