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

export (float) var max_health = 50
onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnTimer

# obstacles code
const TYPE = "player"
# some rope code
var can_grab = true
var rope_grabbed = false
var rope_part = null
var touchingrope = false
func _ready():
	Eventbus.connect("playerspikedamage",self,"_on_playerspikedamage")
	Eventbus.connect("coinpickup",self,"_on_coinpickup")
	Eventbus.connect("playerswingdamage", self, "_on_playerswingdamage")
	Eventbus.connect("touchingrope", self, "_on_touching_rope")
# movement
func _physics_process(delta):
	# left and right movement
	var horizontaldir = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	speed = 400
	_velocity.x = horizontaldir * speed
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, up_dir)
	
	# key character information for functions and animations
	var is_falling = _velocity.y >0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0
	var is_idle = is_on_floor() and is_zero_approx(_velocity.x)
	var is_moving = is_on_floor() and not is_zero_approx(_velocity.x)
	var rope_release = false
	if is_jumping:
		_velocity.y = -jumpstr
	elif is_jump_cancelled:
		_velocity.y = 0

	if rope_grabbed:
		global_position = rope_part.global_position
		if Input.is_action_just_pressed("jump"):
			_velocity.y = -jumpstr/1.5
			rope_grabbed = false
			rope_part = null
			global_position = global_position
			$RopeGrab/RopeTimer.start()
			rope_release = true
			touchingrope = false
		else:
			return
	
# grabbing rope function

# touching rope
func _on_touching_rope():
	touchingrope = true
# if the rope is grabbed by the player and all the conditions are right
func _on_RopeGrab_area_entered(area):
	if can_grab and touchingrope:
		rope_grabbed = true
		rope_part = area
		can_grab = false
		global_position = global_position
# allows the rope to be regrabbed
func _on_RopeTimer_timeout():
	can_grab = true





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
		






# level changing
func _on_level1_body_entered(body):
	get_tree().change_scene("res://Project Files/Worlds/World 1/Level 2/World 1 Level 2.tscn")




func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://Project Files/Worlds/End World/Temp End Level.tscn")




signal health_updated(health)
signal killed()
func kill():
	get_tree().change_scene("res://Project Files/Worlds/End World/Lose End Level.tscn")
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)
	print("HP: %s" % health)
	

# update health function
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health!= prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

# 5 damage taken per spike
func _on_playerspikedamage():
	damage(5)

func _on_playerswingdamage():
	damage(10)
	

onready var coins = 0 

func _on_coinpickup():
	coins+=1
	print("Coins %s " % coins)

