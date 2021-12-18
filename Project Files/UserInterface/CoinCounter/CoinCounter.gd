extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	var coins
	file.open("res://save_coins.txt", File.READ_WRITE)
	coins = int(file.get_as_text())
	file.close()
	$coins.set_text(str(coins))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_player_coinpickedup(coins):
	$coins.set_text(str(coins))
