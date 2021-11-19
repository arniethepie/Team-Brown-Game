extends defaultmovement
var direction = Vector2.ZERO
# direction and movement function of player
func _physics_process(delta):
	# direction vector
	var directionvector = directionvector()
	charaspeed = velocityvector(charaspeed, directionvector, speed)
	# speed calculation
	charaspeed = move_and_slide(charaspeed, Vector2.UP)

	

func directionvector() -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0)
	
	
	
	
	
	
	
# function to calculate our velocity at any moment, makes physics process simpler
func velocityvector(linearvelocity: Vector2, directionvector: Vector2, speed: Vector2) -> Vector2: 
	var finalvelocity = linearvelocity
	finalvelocity.x = speed.x * directionvector.x
	# getting delta value without passing it in
	finalvelocity.y += gravityaccel * get_physics_process_delta_time()
	if directionvector.y == -1.0:
		finalvelocity.y = speed.y * directionvector.y
	
	if finalvelocity.y > speed.y:
		finalvelocity.y = speed.y
	return finalvelocity




"""
# skeleton of animation manager flags, will implement it in future
func animationmanager():
	if Input.is_action_pressed("ui_left"):
		runningleft = true

	elif Input.is_action_pressed("ui_right"):
		runningright = true

	elif Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		running = false
	else:
		# stationary sprite
		stationary = true
"""
