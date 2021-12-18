extends VBoxContainer

onready var bar = $HP


func _on_player_health_updated(health):
	update_health(health)

func _ready():
	var file = File.new()
	var newhp
	file.open("res://save_hp.txt", File.READ)
	bar.max_value = 50
	newhp = int(file.get_as_text())
	update_health(newhp)
	file.close()


func update_health(newhealth):
	bar.value = newhealth
