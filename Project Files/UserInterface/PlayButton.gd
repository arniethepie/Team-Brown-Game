tool 
extends Button

export(String, FILE) var next_scene_path = ""


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
	get_tree().change_scene(next_scene_path)
	

func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""
