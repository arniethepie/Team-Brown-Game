extends Node2D



func _ready():

	var file = File.new()
	file.open("res://save_game_time.txt", File.READ_WRITE)
	$Timetaken.set_text("Time taken: " + file.get_as_text() +"s")
	
	file.open("res://save_coins.txt", File.READ_WRITE)
	$Coins.set_text("Coins: " + file.get_as_text())
	file.open("res://save_totaldmg.txt", File.READ_WRITE)
	$TotalDamageTaken.set_text("Total Damage Taken: " + file.get_as_text())
	
	file.open("res://save_scenes.txt", File.READ_WRITE)
	$TotalDamageTaken.set_text("Total Damage Taken: " + str(4-(file.get_var()[0])))
	
	file.close()
