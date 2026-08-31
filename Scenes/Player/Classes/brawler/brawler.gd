extends Node2D

var attack1_max_t = 60
var attack2_max_t = 120
var attack3_max_t = 180
var attack4_max_t = 90
var attack5_max_t = 900
var ultimate_max_t = 1

var active = false

var wave

var descriptions 

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../Status_effects"

var fist_wave = preload("res://Scenes/Player/Classes/brawler/fist_shockwave.tscn")

func get_description():
	descriptions = {
	"attack_1": ["[b]Punch[/b]\n", "A simple punch that does moderate damage and knockback. Useful for extending combos. \n[color=dodger_blue]Consumes 20 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + strength)\n" % (Global.power + Global.strength), "Cooldown: %.1fs\n" % (float(attack1_max_t)/60), "Knockback: 6\n", "Stuntime: 0.6s\n"],
	"attack_2": ["[b]Flurry[/b]\n", "A punch that sends out 3 waves, each dealing low damage at a moderate range. Beware of attack windup. \n[color=dodger_blue]Consumes 50 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] x3 (33%% + 0.75x str)x3\n" % ((0.33 * Global.power) + (0.75 * Global.strength)),"Cooldown: %.1fs\n" % (float(attack2_max_t)/60), "Knockback: 3 x3\n", "Stuntime: 0.5s\n\n", "Inflicts [color=orange]fire 4[/color] when berserk is active"],
	"attack_3": ["[b]Barrage[/b]\n", "Sends out many small punches which deals small but quickly accumulates damage. Useful for keeping an enemy stunned. \n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] x15 (10%% + 0.2x str)x3\n" % ((0.1 * Global.power) + (0.2 * Global.strength)),"Cooldown: %.1fs\n" % (float(attack3_max_t)/60), "Knockback: 1 x15\n", "Stuntime: 0.5s\n\n", "Inflicts [color=orange]fire 1[/color] when berserk is active"],
	"attack_4": ["[b]Uppercut[/b]\n", "A upwards punch that does moderate damage and sends enemies upwards. Can hit multiple targets. \n[color=dodger_blue]Consumes 30 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + strength)\n" % (Global.power + Global.strength),"Cooldown: %.1fs\n" % (float(attack4_max_t)/60), "Knockback: 6\n", "Stuntime: 1.0s\n\n", "Vertical knockback on enemies that are off ground is a lot less effective"],
	"attack_5": ["[b]Berserk[/b]\n", "Sends the player into a fit of rage which increases their strength by 4 and agility by 6 and boosts stamina regen by 100% for 7.5s. \n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]0[/color] (0)\n", "Cooldown: %.1fs\n" % (float(attack5_max_t)/60), "Knockback: 0\n", "Stuntime: 0s\n\n", "Activates the [color=red]berserk[/color] status effect"],
	}
	return(descriptions)

func set_dir():
	if Global.player_dir == -1:
		class_anim.flip_h = true
	else:
		class_anim.flip_h = false

func init_attack_1():
	if Global.stamina >= 20:
		set_dir()

		Global.stamina -= 20
		Global.attack1t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("punch")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 30:
		class_anim.speed_scale = 2.5
		player.set_speed_penalty(0.25)
		
		# spawns wave
		if Global.attack1t == 20:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			wave.set_damage(Global.power + Global.strength)
			wave.set_knockback(6)
			wave.set_pos(player.position)
			wave.set_speed(0, 0)
			wave.set_stuntime(36)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if between(Global.attack1t, 20, 30):
			wave.set_pos(player.position + Vector2((Global.player_dir * 7.75 * Global.attack1t) - (Global.player_dir * 95), -85))

		if Global.attack1t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack1t >= 1:
		Global.attack1t += 1

	if Global.attack1t >= attack1_max_t:
		Global.attack1t = 0

func init_attack_2():
	if Global.stamina >= 50:
		set_dir()

		Global.stamina -= 50
		Global.attack2t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("punch")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 34:
		class_anim.speed_scale = 1.75
		player.set_speed_penalty(0.05)
		
		# spawns wave
		if between(Global.attack2t, 30, 34) and Global.attack2t % 2 == 0:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			if status.get_berserk():
				wave.set_fire(4)
			wave.set_damage((0.33 * Global.power) + (0.75 * Global.strength))
			wave.set_knockback(3)
			wave.set_size(2)
			wave.set_stuntime(60)
			wave.set_pos(Vector2(player.position.x, player.position.y + randi_range(-150, -20)))
			wave.set_speed(40 + randi_range(-10,20), 0)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if Global.attack2t == 34:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 60:
		set_dir()

		Global.stamina -= 60
		Global.attack3t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("barrage")
		Global.attack3t = 1
		player.set_attacking(true)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 60:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.1)
		
		# spawns wave
		if between(Global.attack3t, 4, 60) and Global.attack3t % 4 == 0:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			if status.get_berserk():
				wave.set_fire(1)
			wave.set_damage((0.1 * Global.power) + (0.2 * Global.strength))
			wave.set_knockback(1)
			wave.set_size(2.5)
			wave.set_lifetime(5)
			wave.set_stuntime(30)
			wave.set_pos(Vector2(player.position.x + (80 * Global.player_dir), player.position.y + randi_range(-130, -60)))
			wave.set_speed(20, 0)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if Global.attack3t == 60:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 30:
		set_dir()

		Global.stamina -= 30
		Global.attack4t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("uppercut")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 30:
		class_anim.speed_scale = 2.8
		player.set_speed_penalty(0.1)
		
		# spawns wave
		if Global.attack4t == 15:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			wave.set_damage(Global.power + Global.strength)
			wave.set_knockback(6)
			wave.set_knockbackY(-14)
			wave.set_size(4.5)
			wave.set_stuntime(60)
			wave.set_hitnum(10)
			wave.set_lifetime(10)
			wave.set_pos(Vector2(player.position.x + (80 * Global.player_dir), player.position.y + randi_range(-130, -60)))
			wave.set_angle(30 * Global.player_dir)
			wave.set_speed(2, -15)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if Global.attack4t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack4t >= 1:
		Global.attack4t += 1

	if Global.attack4t >= attack4_max_t:
		Global.attack4t = 0

func init_attack_5():
	if Global.stamina >= 0:
		set_dir()

		Global.stamina -= 0
		Global.attack5t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("scream")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 45:
		class_anim.speed_scale = 9
		player.set_speed_penalty(0)
		
		# spawns wave
		if Global.attack5t == 20:
			status.set_berserk(450)

		if Global.attack5t == 45:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack5t >= 1:
		Global.attack5t += 1

	if Global.attack5t >= attack5_max_t:
		Global.attack5t = 0

func between(variable, time1, time2):
	if variable >= time1 and variable <= time2:
		return(true)
	else:
		return(false)

func update_global_cds():
	Global.attack1_max_t = attack1_max_t
	Global.attack2_max_t = attack2_max_t
	Global.attack3_max_t = attack3_max_t 
	Global.attack4_max_t = attack4_max_t
	Global.attack5_max_t = attack5_max_t
	Global.ultimate_max_t = ultimate_max_t

func set_active(value):
	active = value

func _physics_process(_delta: float) -> void:
	if active:
		update_global_cds()
		attack_1()
		attack_2()
		attack_3()
		attack_4()
		attack_5()
