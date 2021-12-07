extends defaultmovement
var direction = Vector2.ZERO
var scale_flag = true
export var speed = 400
const up_dir = Vector2.UP
export var max_jumps = 2
export var jumpstr = 1200
export var gravity = 3000

var _currentjumps = 0
var _velocity = Vector2.ZERO


# obstacles code
const TYPE = "player"
export var hp = 5

# movement
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
		

# animations
onready var _animation_move_player = $move
onready var _animation_move2_player = $move2
onready var _animation_idle_player = $idle
onready var _animation_jump_player = $jump
onready var _animation_run_player = $run

func _process(_delta):
	
	var axisX = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# move right
	if axisX > 0:
		# _animation_idle_player.stop()			#stop idle animation
		if is_on_floor():
			_animation_move_player.play("move")		#play move animation
		if scale_flag == false:		# scale the character if the direction of motion changes
			scale_flag = true
			get_node("Knight").apply_scale(Vector2(-1, 1))		#scale the character
	#move left
	elif axisX < 0:
		# _animation_idle_player.stop()			#stop idle animation
		if is_on_floor():
			_animation_move_player.play("move")		#play move animation
		if scale_flag == true:		# scale the character if the direction of motion changes
			scale_flag = false
			get_node("Knight").apply_scale(Vector2(-1, 1))		#scale the character
			
	else:
		_animation_move_player.stop()	#stop move animation
		_animation_idle_player.play("idle")		#play idle animation
		
	if Input.is_action_just_pressed("jump"):
		# _animation_idle_player.stop()
		_animation_move_player.stop()	#stop move animation
		_animation_jump_player.play("jump")		#play jump animation
		







func _on_level1_body_entered(body):
	get_tree().change_scene("res://Project Files/Worlds/World 1/Level 2/World 1 Level 2.tscn")



func _on_level2_body_entered(body):
		get_tree().change_scene("res://Project Files/Worlds/End World/Temp End Level.tscn")
