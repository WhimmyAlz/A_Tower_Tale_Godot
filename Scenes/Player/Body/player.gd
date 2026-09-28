extends CharacterBody2D

var jumps
var jump_pause

var attacking = false

var free := true # Used for stunned, frozen, unable to move, etc
var hat_mode = "idle" # hat is idle when jumping or idle, otherwise stunned or run

var speed_penalty := 0.2 # used as a speed multiplier
var regen_amount = 0
var regen_cooldown_time = 0

var damage_text = preload("res://Scenes/Mobs/UI/Damage_text/damage_text.tscn")

var quick_regen = false

func check_between_time():
	var merchant_is_only_mob = get_tree().current_scene.get_node("Enemies").get_child_count() == 1 and get_tree().current_scene.get_node("Enemies").get_child(0).is_in_group("merchant")
	var merchant_passive = false
	if merchant_is_only_mob:
		merchant_passive = get_tree().current_scene.get_node("Enemies").get_child(0).get_passive()
		
	quick_regen = merchant_passive

func reset_regen_amount():
	regen_amount = int((Global.health_regen_value * 0.01) * Global.max_health)

func get_regen_amount():
	return(regen_amount)

func health_regen():
	if regen_amount > 0 and Global.health != Global.max_health and regen_cooldown_time == 0:
		Global.health += 1
		regen_amount -= 1
		if quick_regen:
			regen_cooldown_time = 3
		else:
			regen_cooldown_time = 15
	
	if regen_cooldown_time > 0:
		regen_cooldown_time -= 1

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
	
	if not attacking and velocity.y > -100 and Global.stun_time == 0 and Input.is_action_pressed("down"):
		velocity.y += 400

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

func unlock_attack(amount):
	Global.player_attacks += amount
	$"../Non Attached UI Elements/MoveList".unhide_attacks()

func unlock_ultimate():
	Global.ultimate_attack = 1
	$"../Non Attached UI Elements/MoveList".unhide_attacks()

# Next few functions are used for stat changes

## changes health and sets the hp bar
func take_damage(value, defense_pen, color = Color.WHITE_SMOKE):
	# makes sure health doesn't go below 0
	var def = maxi(Global.defense - defense_pen, 0)
	var damage =  maxf(value - def, 1)
	Global.health = maxi(Global.health - damage, 0)
	$"../Non Attached UI Elements/Prog_Bars".Update_HP()
	
	# fixes 1.0 to 1 for damage text
	if is_zero_approx(damage - int(damage)):
		damage = int(damage)
	else: 
		damage = snapped(damage, 0.1)
	var damageText = damage_text.instantiate()
	damageText.set_text(damage)
	damageText.set_position(position + Vector2(0, -400))
	damageText.set_color(color)
	damageText.set_size(1 + (float(damage)/50))
	get_tree().current_scene.get_node("Damage_text").add_child(damageText)

func take_knockback(kb, dir):
	self.velocity.x += kb * dir * 100 # 100 cuz kb too weak otherwise (want to use lower values)

func get_status_effect():
	return(get_parent().get_status_effect())

func take_stun(stun_time):
	
	var status_effects = get_parent().get_status_effect()
	var shock_stacks = status_effects.get_shock()

	# checks if player has shocks or is stunned to apply extra stun if shocked
	if shock_stacks == 0 or Global.stun_time == 0: 
		Global.stun_time = stun_time
	else:
		Global.stun_time += int(stun_time * shock_stacks/100)

	# Creates a stunned status box
	if status_effects.check_dupes("Stunned"):
		status_effects.update_status_box("Stunned", 1, Global.stun_time)
	else:
		status_effects.init_status_box("Stunned", 1, Global.stun_time, Color.WHITE)

func gain_xp(amount):
	Global.player_XP += amount

func gain_stamina(value):
	if Global.stamina < Global.max_stamina:
		Global.stamina = minf(Global.stamina + value, Global.max_stamina)
		$"../Non Attached UI Elements/Prog_Bars".Update_STAM()

func stamina_regen():
	if Global.stamina < Global.max_stamina:
		if quick_regen:
			Global.stamina = minf(Global.stamina + (1 + Global.stamina_regen_multi) * 1, Global.max_stamina)
		else:
			Global.stamina = minf(Global.stamina + (1 + Global.stamina_regen_multi) * 0.5, Global.max_stamina)
		$"../Non Attached UI Elements/Prog_Bars".Update_STAM()

func _ready() -> void:
	player_friction() # calls friction function 
	player_movement() # calls player movement function 
	vert_velocities() # calls player vertical movement function

func _physics_process(_delta: float):
	check_between_time()
	stamina_regen()
	health_regen()
	check_free()

	# Movement functions
	player_friction() # calls friction function 
	player_movement() # calls player movement function 
	vert_velocities() # calls player vertical movement function

	move_and_slide() # allows for colision and stuff
