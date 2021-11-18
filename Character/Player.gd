extends defaultmovement






""""
# initial basic character movement script
export(float) var movementspeed = 100
#export(float) var acceleration = 200
# variables for checking animations=, if true, then animation of the sprite will play
var runningleft = false
var runningright = false
var running = false
# if character is afk for X seconds, then play a resting animation where he sits down
var resting = false
var stationary = true

# character speed variable
var velocity = Vector2.ZERO

# wasd movement
func _physics_process(delta):
	var inputvector = Vector2.ZERO
	
	inputvector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputvector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = inputvector * movementspeed
	
	# if(directional_input != Vector2.ZERO):
	#	velocity = velocity.move_toward(inputvector * movement_speed, acceleration * delta)
	
	move_and_slide(velocity)
	

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
