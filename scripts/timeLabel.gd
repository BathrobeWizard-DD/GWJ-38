extends Label

export var countdown = 60

var minutes = 0
var seconds = 0
var milliseconds = 0
var minutesString = "00"

func _ready():
	pass

func _process(delta):
	milliseconds = OS.get_ticks_msec()/10 % 100
	seconds = OS.get_ticks_msec()/1000 % 60
	
	if OS.get_ticks_msec()/1000 % 61 == 60 :
		minutes = (OS.get_ticks_msec()/1000 + 1) % 60
		minutesString = str(minutes)
		if minutes < 10:
			minutesString = str(0,minutes)
	if milliseconds < 10:
		milliseconds = str(0,milliseconds)
	if seconds < 10:
		seconds = str(0,seconds)
	text = str(minutesString,":",seconds,":",milliseconds)
