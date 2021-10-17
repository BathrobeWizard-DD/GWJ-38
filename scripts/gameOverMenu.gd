extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func showGameOver():
	visible = true

func _on_playAgain_pressed():
	get_tree().change_scene("res://scenes/mcMovementTesting_Autorunner.tscn")


func _on_mainMenu_pressed():
	get_tree().change_scene("res://scenes/menus/startMenu.tscn")
	pass # Replace with function body.


func _on_BlackHole_mainCharEntered():
	showGameOver()
	pass # Replace with function body.