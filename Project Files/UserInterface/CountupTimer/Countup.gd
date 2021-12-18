extends Control

export (int) var total_seconds = 0
onready var filetimer = get_node("FileTimer")

func _ready():
	# filetimer.connect("timeout", self, "_on_Timer_timeout")
	filetimer.set_wait_time(1.0) # Call timeout function every second
	filetimer.set_one_shot(false) # Make sure it loops
	filetimer.start()


func _on_FileTimer_timeout():
	var file = File.new()
	file.open("res://save_game_time.txt", File.READ_WRITE)
	total_seconds = int(file.get_as_text())
	
	total_seconds += 1
	
	# Print the number of time	
	var secs = "%d" % total_seconds
	$sec.set_text(str(secs))
	file.store_string(str(secs))
