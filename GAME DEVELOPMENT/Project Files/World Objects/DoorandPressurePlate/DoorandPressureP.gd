extends Node2D
var open = false


func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player" and open == false:
		$ButtonAnimationPlayer.play("Platedown")
		$DoorAnimationPlayer.play("DoorOpening")
		open = true
