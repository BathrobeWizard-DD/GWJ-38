extends Control

func _on_Resume_pressed():
	ButtonPress.play()
	visible = false
	var countdownNode = get_node("../unpauseCountdown")
	countdownNode.beginTimer()
	yield(countdownNode, "timerFinished")
	set_pause(false)

func _on_mainMenu_pressed():
	ButtonPress.play()
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menus/startMenu.tscn")

func set_pause(val):
	get_tree().paused = val
	visible = val

# Called when the node enters the scene tree for the first time.
func _ready():
	$Resume.emit_signal("pressed")
#	set_pause(false)

func _input(event):
	if event.is_action_pressed("pauseGame"):
		var countdownNode = get_node("../unpauseCountdown")
		if (not countdownNode.isActive):
			set_pause(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

