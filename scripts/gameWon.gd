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


func _on_Label_score_updated():
	$currentScore.text = str("Score\n", Score.current_score_string)
	$highScore.text = str("High Score\n", Score.score_string)
