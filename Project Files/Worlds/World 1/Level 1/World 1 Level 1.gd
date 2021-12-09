extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _on_body_entered(body):
	
	get_tree().change_scene("res://Project Files/Worlds/World 1/")
