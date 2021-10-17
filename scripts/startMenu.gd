extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_btnStartGame_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://levels/LevelOnePlayable.tscn")


func _on_btnCredits_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://scenes/menus/creditsMenu.tscn")


func _on_btnOptions_pressed():
	ButtonPress.play()
	get_tree().change_scene("res://scenes/menus/optionsMenu.tscn")
