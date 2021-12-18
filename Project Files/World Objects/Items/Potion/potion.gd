extends Area2D

onready var anim_player: AnimationPlayer = get_node("CollisionShape2D/AnimationPlayer")

func _on_body_entered(body: PhysicsBody2D) -> void:
	Eventbus.emit_signal("potionpickup")
	anim_player.play("fade_out")
