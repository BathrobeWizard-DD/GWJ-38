extends Label

export var starting_time = 60
onready var time_remaining = starting_time 
var start = true
var time_accumulation = 0
var minutes = 0
var seconds = 0
var milliseconds = 0
var minutesString = "00"
var secondsString = "00"
var millisecondString = "00"
var time_left_milli = 0
var time_left_sec = 0
var time_left_min = 0
var first_second = true
signal timedOut()

func _ready():
	pass

func _process(delta):
	if start:
		process_count_up_timer(delta)
		time_left()
	text = time_left_to_string()

func process_count_up_timer(delta):
	time_accumulation += delta
	milliseconds = int(time_accumulation * 100) % 100
	seconds = int(time_accumulation) % 60
	
	if int(time_accumulation) % 61 == 60 :
		minutes = (int(time_accumulation) + 1) % 60
		minutesString = str(minutes)
		if minutes < 10:
			minutesString = str(0,minutes)
		else:
			minutesString = str(minutes)

func time_to_string():
	if milliseconds < 10:
		millisecondString = str(0,milliseconds)
	else:
		millisecondString = str(milliseconds)
	if seconds < 10:
		secondsString = str(0,seconds)
	else:
		secondsString = str(seconds)
	return str(minutesString,":",secondsString,":",millisecondString)

func time_left():
	print(str(time_remaining,":", time_left_milli))
	time_remaining = (starting_time - 1) - seconds
	time_left_milli = 99 - milliseconds
	if time_remaining <= 0:
		time_left_sec = 0
		time_remaining = 0
	
	if time_remaining > 60:
		time_left_sec = (time_remaining % 60)
		time_left_min = time_remaining / 60
	elif time_remaining == 60:
		time_left_sec = 59
		time_left_min = 0
	elif time_remaining > 0: 
		time_left_sec = time_remaining
		time_left_min = 0
	elif time_remaining == 0 && time_left_milli < 5:
		time_left_milli = 0
		emit_signal("timedOut")
		start = false

func time_left_to_string():
	if time_left_milli < 10:
		millisecondString = str(0,time_left_milli)
	else:
		millisecondString = str(time_left_milli)
	if time_left_sec < 10:
		secondsString = str(0,time_left_sec)
	else:
		secondsString = str(time_left_sec)
	if time_left_min < 10:
		minutesString = str(0,time_left_min)
	else:
		minutesString = str(time_left_min)
	return str(minutesString,":",secondsString,":",millisecondString)
