extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Swing")




func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player":
		Eventbus.emit_signal("playerswingdamage")
