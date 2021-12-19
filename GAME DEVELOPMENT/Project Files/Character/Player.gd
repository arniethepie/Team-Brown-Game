extends defaultmovement
var direction = Vector2.ZERO
var scale_flag = true
export var speed = 400
const up_dir = Vector2.UP
export var max_jumps = 2
export var jumpstr = 1200
export var gravity = 3000

export (float) var max_health = 50

onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnTimer

var _currentjumps = 0
var _velocity = Vector2.ZERO
# total dmg variable
var totaldmg
# obstacles code
const TYPE = "player"
# some rope code
var can_grab = true
var rope_grabbed = false
var rope_part = null
var touchingrope = false
var rng = RandomNumberGenerator.new()
func _ready():
	# generate random seeds
	rng.randomize()
	var file = File.new()
	Eventbus.connect("playerspikedamage",self,"_on_playerspikedamage")
	Eventbus.connect("coinpickup",self,"_on_coinpickup")
	Eventbus.connect("playerswingdamage", self, "_on_playerswingdamage")
	Eventbus.connect("touchingrope", self, "_on_touching_rope")
	Eventbus.connect("potionpickup", self, "_on_potionpickup")
	Eventbus.connect("levelchange",self, "_on_level_change")
	file.open("res://save_hp.txt", File.READ_WRITE)
	health = int(file.get_as_text())
	file.close()
	invuln_animation.play("Rest")

	
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





# animations and sounds
# audio from yespik.com copyright free
onready var _animation_move_player = $move
onready var _animation_move2_player = $move2
onready var _animation_idle_player = $idle
onready var _animation_jump_player = $jump
onready var _animation_run_player = $run
onready var invuln_animation = $InvulnAnimation
onready var Run_sound = $Runsound
onready var Jump_sound = $Jumpsound
onready var Coin_sound = $Coinsound
onready var Hurt1_sound = $Hurt1sound
onready var Hurt2_sound = $Hurt2sound
# animation and sound function
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
		Run_sound.play()
		_animation_idle_player.play("idle")		#play idle animation
		
	if Input.is_action_just_pressed("jump"):
		# _animation_idle_player.stop()
		_animation_move_player.stop()	#stop move animation
		_animation_jump_player.play("jump")		#play jump animation
		Jump_sound.play()







	
# random scene changer
func randchangescenes():
	var sceneslist
	var scenes = []
	var file = File.new()
	
	file.open("res://save_scenes.txt", File.READ_WRITE)
	sceneslist = file.get_var()
	var randomscenenum = rng.randi_range(1,len(sceneslist)-1)
#	var randomscenenum = (randi()%(len(sceneslist)+1) - 1)
	# counts how many levels we have gone through
	if sceneslist[0] == 0:
		file.close()
		return "res://Project Files/Worlds/End World/Temp End Level.tscn"
	else:
		file.close()
		file.open("res://save_scenes.txt", File.WRITE)
		sceneslist[0] -= 1
		var nextscene = sceneslist[randomscenenum]
		sceneslist.remove(randomscenenum)
		file.store_var(sceneslist)
		file.close()
		return nextscene
		
		
		
# level changing
func _on_level_change():
	get_tree().change_scene(randchangescenes())


signal health_updated(health)
signal killed()
# death function
func kill():
	get_tree().change_scene("res://Project Files/Worlds/End World/Lose End Level.tscn")


# damage function
func damage(amount):
	# if potion is taken, ignore invuln timer
	if amount<0:
		_set_health(health-amount)
		invuln_animation.play("regen")
	if invulnerability_timer.is_stopped():
		var file = File.new()
		if amount > 0:
			file.open("res://save_totaldmg.txt", File.READ_WRITE)
			totaldmg = int(file.get_as_text()) + amount
			file.store_string(str(totaldmg))
			file.close()
			invulnerability_timer.start()
			_set_health(health-amount)
			Hurt1_sound.play()
			invuln_animation.play("damage")
			invuln_animation.queue("flash")

	#print("HP: %s" % health)





# update health function
func _set_health(value):
	var file = File.new()
	file.open("res://save_hp.txt", File.READ_WRITE)
	health = int(file.get_as_text())
	var prev_health = health
	health = clamp(value, 0, max_health)
	file.store_string(str(health))
	file.close()
	if health!= prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")




func _on_InvulnTimer_timeout():
	invuln_animation.play("Rest")

# 2.5 damage taken per spike
func _on_playerspikedamage():
	damage(2.5)
	
# take 5 damage for swinging axe
func _on_playerswingdamage():
	damage(5)


onready var coins = 0
signal coinpickedup(coins)
# +1 coin on coin pickup
func _on_coinpickup():
	var file = File.new()
	file.open("res://save_coins.txt", File.READ_WRITE)
	coins = int(file.get_as_text())
	coins+=1
	file.store_string(str(coins))
	file.close()
	emit_signal("coinpickedup", coins)
	Coin_sound.play()

# heal 20 on potion pickup
func _on_potionpickup():
	damage(-20)
	Coin_sound.play()

