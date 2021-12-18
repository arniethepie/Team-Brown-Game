extends VBoxContainer

var maximum_value = 100


func initialize(maximum):
	maximum_value = 100
	var file = File.new()
	file.open("res://save_hp.txt", File.READ_WRITE)
	$TextureProgress.max_value = maximum

func _on_Interface_health_changed(health):
	$TextureProgress.value = health
	$Counter/Label.text = "%s / %s" %[health, maximum_value]


func _on_player_health_updated(health):
	$TextureProgress.value = health/100
	
