extends KinematicBody2D
class_name defaultmovement

var charaspeed = Vector2.ZERO
export var gravityaccel = 3000.0
export var maxspeed = Vector2(300.0,1000.0)
# physics process is called every frame of the game

# delta is the amount of time elapsed since last frame
func _physics_process(delta):
	charaspeed.y += gravityaccel * delta
	if charaspeed.y > maxspeed.y:
		charaspeed.y = maxspeed.y
	charaspeed = move_and_slide(charaspeed)
	
