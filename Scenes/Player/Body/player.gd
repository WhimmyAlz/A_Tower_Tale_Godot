extends CharacterBody2D

var jumps
var jump_pause

var attacking = false

var free := true # Used for stunned, frozen, unable to move, etc
var hat_mode = "idle" # hat is idle when jumping or idle, otherwise stunned or run

var speed_penalty := 0.2 # used as a speed multiplier

## Slows down the player's velocity when it's not zero.
func player_friction():
	if velocity.x > 0:
		velocity.x = maxf(velocity.x - Global.player_weight, 0)
	elif velocity.x < 0:
		velocity.x = minf(velocity.x + Global.player_weight, 0)

## Checks for player's inputs and adds speed based on results, also sets the running and idle animations.
func player_movement():
	$AnimatedSprite2D.speed_scale = (Global.player_spd * 0.035)
	if Input.is_action_pressed("left") and free:
		position.x -= Global.player_spd * attack_speed_penalty(speed_penalty)
		if not jump_pause:
			$AnimatedSprite2D.play("run")
			hat_mode = "run"
		direction_change_free(-1)
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("right") and free:
		position.x += Global.player_spd * attack_speed_penalty(speed_penalty)
		if not jump_pause:
			$AnimatedSprite2D.play("run")
			hat_mode = "run"
		direction_change_free(1)
		$AnimatedSprite2D.flip_h = false
	elif not jump_pause:
		$AnimatedSprite2D.play("idle")
		hat_mode = "idle"

## Sets the gravity and values of jumps for the player. Also checks for player input on jumps and allows jumping. (fix colision with ceiling issue)
func vert_velocities():
	if not attacking or velocity.y < 30:
		velocity.y += Global.Gravity
	elif attacking and velocity.y > 30:
		velocity.y = 30
		

	if is_on_floor():
		jumps = Global.max_jumps
		jump_pause = false
		$"Attached UI Elements/Jump_bar".hide()

	elif Global.max_jumps == 1:
		jumps = 0

	# Jump bar
	if jumps != Global.max_jumps:
		$"Attached UI Elements/Jump_bar".show()
		$"Attached UI Elements/Jump_bar".value = jumps
		$"Attached UI Elements/Jump_bar".max_value = Global.max_jumps

	# Jump conditions
	if Input.is_action_pressed("up") and jumps > 0 and velocity.y > -Global.jump_limit and free:

		# Head distance check
		var raycast_len = -(Global.jump_power * 0.15)
		var object 
		var jump_blocked = false

		# Sets raycast vertical length 
		$RayCast2D.target_position = Vector2(0, raycast_len)

		if $RayCast2D.is_colliding():

			object = $RayCast2D.get_collider()

			if object.get_parent().is_in_group("Ceiling"):
				jump_blocked = true

		if not jump_blocked:
			jump()

## Sets velocities and animations
func jump():
	var jump_power = -Global.jump_power
	jump_pause = true
	hat_mode = "jump"
	$AnimatedSprite2D.play("run")
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.pause()
	if Global.flight == 1 and jumps == Global.max_jumps:
		jump_power = -Global.jump_limit * 4
	velocity.y = jump_power
	jumps -= 1

## sets if player is free based on stuns
func check_free():
	if Global.stun_time >= 1:
		free = false
		Global.stun_time -= 1
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.frame = 0
	else:
		free = true

## returns how the hat should be set
func get_hat_mode():
	return(hat_mode)

## sets if player is currently attacking
func set_attacking(boolean):
	if boolean is bool:
		attacking = boolean

func get_attacking():
	return(attacking)

## sets a speed penalty when attacking
func set_speed_penalty(penalty):
	self.speed_penalty = penalty

## returns a speed multi after checking if attacking
func attack_speed_penalty(penalty):
	if attacking == true:
		return(penalty)
	else:
		return(1)

## returns direction if not in action
func direction_change_free(value):
	if attacking == false:
		Global.player_dir = value

## toggles animation visiblity
func set_animation_visibility(boolean):
	if boolean is bool:
		$AnimatedSprite2D.visible = boolean

# Next few functions are used for stat changes

## changes health and sets the hp bar
func take_damage(value, defense_pen):
	# makes sure health doesn't go below 0
	var def = maxi(Global.defense - defense_pen, 0)
	var damage =  maxi(value - def, 1)
	Global.health = maxi(Global.health - damage, 0)
	$"../Non Attached UI Elements/Prog_Bars".Update_HP()

func take_knockback(kb, dir):
	self.velocity.x += kb * dir * 100 # 100 cuz kb too weak otherwise (want to use lower values)

func take_stun(stun_time):
	Global.stun_time = stun_time

func gain_xp(amount):
	Global.player_XP += amount

func gain_stamina(value):
	if Global.stamina < Global.max_stamina:
		Global.stamina = minf(Global.stamina + value, Global.max_stamina)
		$"../Non Attached UI Elements/Prog_Bars".Update_STAM()

func stamina_regen():
	if Global.stamina < Global.max_stamina:
		Global.stamina += (1 + Global.stamina_regen_multi) * 0.5
		$"../Non Attached UI Elements/Prog_Bars".Update_STAM()

func _ready() -> void:
	player_friction() # calls friction function 
	player_movement() # calls player movement function 
	vert_velocities() # calls player vertical movement function

func _physics_process(_delta: float):
	
	stamina_regen()
	check_free()

	# Movement functions
	player_friction() # calls friction function 
	player_movement() # calls player movement function 
	vert_velocities() # calls player vertical movement function

	move_and_slide() # allows for colision and stuff
