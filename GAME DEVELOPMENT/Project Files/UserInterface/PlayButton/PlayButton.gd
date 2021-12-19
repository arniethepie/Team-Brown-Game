tool 
extends Button

export(String, FILE) var next_scene_path = ""

var scenes = [3,"res://Project Files/Worlds/World 1/All Worlds/Level2A.tscn","res://Project Files/Worlds/World 1/All Worlds/Level3A.tscn","res://Project Files/Worlds/World 1/All Worlds/Level4A.tscn","res://Project Files/Worlds/World 1/All Worlds/Level5A.tscn","res://Project Files/Worlds/World 1/All Worlds/Level6A.tscn"]

func _on_button_up():
	var file = File.new()
	file.open("res://save_game_time.txt", File.WRITE)
	file.store_string(str(0))
	file.close()
	file.open("res://save_hp.txt", File.WRITE)
	file.store_string(str(50))
	file.close()
	file.open("res://save_coins.txt", File.WRITE)
	file.store_string(str(0))
	file.close()
	file.open("res://save_totaldmg.txt", File.WRITE)
	file.store_string(str(0))
	file.open("res://save_scenes.txt", File.WRITE)
	file.store_var(scenes)
	file.close()
	get_tree().change_scene("res://Project Files/Worlds/World 1/All Worlds/Level1A.tscn")
	

func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""


# declaration

