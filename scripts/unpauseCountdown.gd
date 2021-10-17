extends Control

const timerInterval = 0.8
export var timerStart = 3
var currentTime

var isActive = true

signal timerFinished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func updateTimerText(inputText):
	$countdownTimer.set_text(inputText)

func beginTimer():
	isActive = true
	get_tree().paused = true
	visible = true
	currentTime = timerStart
	updateTimerText(str(currentTime))
	$TimerObj.start(timerInterval)
	print(self.rect_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TimerObj_timeout():
	currentTime -= 1
	if (currentTime > 0):
		updateTimerText(str(currentTime))
	else:
		visible = false
		isActive = false
		$TimerObj.stop()
		call_deferred("emit_signal", "timerFinished")
