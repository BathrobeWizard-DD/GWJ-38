extends Control

func _ready():
	visible = false

func showGameOver():
	get_parent().get_node("Label").pause_timer()
	visible = true

func _on_playAgain_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://levels/LevelOnePlayable.tscn")


func _on_mainMenu_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://scenes/menus/startMenu.tscn")
	pass # Replace with function body.


func _on_BlackHole_mainCharEntered():
	showGameOver()
	pass # Replace with function body.


func _on_Label_timedOut():
	showGameOver()
	pass # Replace with function body.
