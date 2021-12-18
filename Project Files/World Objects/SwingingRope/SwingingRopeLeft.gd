extends Node



func _ready():
	$AnimationPlayer.play("RopeSwingLeft")

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		Eventbus.emit_signal("touchingrope")

