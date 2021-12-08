extends Area2D


func _ready():
	$AnimationPlayer.play("Spiketrap")



func _on_SpikeTrap_body_entered(body):
	if body.get("TYPE") == "player":
		Eventbus.emit_signal("playerspikedamage")
