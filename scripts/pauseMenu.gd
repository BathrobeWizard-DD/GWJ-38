extends Control

func _on_Resume_pressed():
	set_pause(false)

func _on_mainMenu_pressed():
	get_tree().change_scene("res://scenes/menus/startMenu.tscn")

func set_pause(val):
	get_tree().paused = val
	visible = val

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pause(false)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pauseGame"):
		set_pause(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

