extends Control

func _ready():
	visible = false

func gameWon():
	visible = true

func _on_playAgain_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://levels/LevelOnePlayable.tscn")


func _on_mainMenu_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://scenes/menus/startMenu.tscn")
	pass # Replace with function body.


func _on_worldWrapperThing_body_entered(body):
	if (body.get_name() == "mainChar"):
		gameWon()
