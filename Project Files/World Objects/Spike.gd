extends KinematicBody2D
signal playerdamage

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		Eventbus.emit_signal("playerspikedamage")
#		get_tree().reload_current_scene()
	
