extends defaultmovement


export var speed = 400
const up_dir = Vector2.UP
export var max_jumps = 2
export var jumpstr = 1200
export var gravity = 3000

var _currentjumps = 0
var _velocity = Vector2.ZERO

func _physics_process(delta):
	# left and right movement
	var horizontaldir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	_velocity.x = horizontaldir * speed
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, up_dir)
	
	# key character information for functions and animations
	var is_falling = _velocity.y >0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0
	var is_idle = is_on_floor() and is_zero_approx(_velocity.x)
	var is_moving = is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_jumping:
		_velocity.y = -jumpstr
	elif is_jump_cancelled:
		_velocity.y = 0
		
		# add animations
		
	# if jumping: set animation sprite to jumping
	# if moving: set animation sprite to running
	
	
	


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


func _on_level1_body_entered(body):
	get_tree().change_scene("res://Project Files/Worlds/World 1/Level 2/World 1 Level 2.tscn")



func _on_level2_body_entered(body):
		get_tree().change_scene("res://Project Files/Worlds/End World/Temp End Level.tscn")
