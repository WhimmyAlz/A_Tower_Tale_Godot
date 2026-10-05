extends Node2D

var attack1_max_t = 60
var attack2_max_t = 360
var attack3_max_t = 180
var attack4_max_t = 360
var attack5_max_t = 900
var ultimate_max_t = 90

var active = false

var stab_wave
var wave

var explosion
var reaper_slice
var descriptions 
var closest_enemy

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../../Non Attached UI Elements/Status_effects"

var stab_wave_preload = preload("res://Scenes/Player/Classes/paladin/stab_wave.tscn")

var explosion_preload = preload("res://Scenes/Player/Classes/reaper/explosion.tscn")
var reaper_slice_preload = preload("res://Scenes/Player/Classes/reaper/reaper_slice.tscn")

var used_styx_souls = 0
var total_targets

func get_description():
	descriptions = {
	"attack_1": ["[b]Sword thrust[/b]\n", "Spawns a sword in your hands and stab in a forward direction with it.\n[color=dodger_blue]Consumes 45 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + 0.75 x Strength)\n" % (Global.power + 0.75 * Global.strength), "Cooldown: %.2fs\n" % (float(attack1_max_t)/60), "Knockback: 12\n", "Stuntime: 0.75s\n"],
	"attack_2": ["[b]Beams of Judgment[/b]\n", "Sets enemies on fire using the power of God and Anime. Damage from this attack increases with your iq points.\n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]0[/color] (0)\n","Cooldown: %.2fs\n" % (float(attack2_max_t)/60), "Knockback: 0\n", "Stuntime: 0.5s\n\n", "Enemies hit are inflicted with [color=orange]fire X[/color] (X = int/2)."],
	"attack_3": ["[b]Shield bash[/b]\n", "Dashes forward with a shield infront of you, shoving any enemy in your way. Defensive stance is activated while using the shield. \n[color=dodger_blue]Consumes 55 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + Strength)\n" % (Global.power + Global.strength),"Cooldown: %.2fs\n" % (float(attack3_max_t)/60), "Knockback: 30\n", "Stuntime: 1.25s\n\n", "Activates [color=dim_gray]Defensive Stance 3[/color]"],
	"attack_4": ["[b]Retribution[/b]\n", "Performs a powerful slice that carries enemies dealing 10% of intial damage per tick. Does more damage the more retibution stacks you have.\n[color=dodger_blue]Consumes 75 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] 250-750%%\n" % (Global.power * 2.5),"Cooldown: %.2fs\n" % (float(attack4_max_t)/60), "Knockback: 4\n", "Stuntime: 0.5s"],
	"attack_5": ["[b]Borrowed time[/b]\n", "Creates a shield that heals you for all your damage taken, but it all gets dealt back to you after the shield wears off. The damage is reduced by the amount of retribution that you have.\n[color=dodger_blue]Consumes 30 stamina.[/color]\n\n", "Damage: [color=red]0[/color] (0)\n", "Cooldown: %.2fs\n" % (float(attack5_max_t)/60), "Knockback: 0\n", "Stuntime: 0s\n\n", "Activates [color=sky_blue]Borrowed Time[/color]"],
	"ultimate": ["[b]Holy Impalement[/b]\n", "Spawns an area that heals 4hp/s and summons skulls who frequently casts soul explosions to a random mob for 10s. Consumes up to 2 Souls to increase time by 3.5s each.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (25%%)\n" % (0.25 * Global.power), "Cooldown: %.2fs\n" % (float(ultimate_max_t)/60), "Knockback: 0\n", "Stuntime: 0s\n", "Sometimes a super explosion spawns which deals 200% instead of 25%"],
	}
	return(descriptions)

func set_dir():
	if Global.player_dir == -1:
		class_anim.flip_h = true
	else:
		class_anim.flip_h = false

func init_attack_1():
	if Global.stamina >= 45:
		set_dir()

		Global.stamina -= 45
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("paladin_stab")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 35:
		class_anim.speed_scale = 2
		player.set_speed_penalty(0.25)
		
		# spawns stab_wave
		if Global.attack1t == 24:
			stab_wave = stab_wave_preload.instantiate()
			stab_wave.set_player(player)
			stab_wave.set_damage(Global.power + (0.75 * Global.strength))
			stab_wave.set_knockback(12)
			stab_wave.set_pos(player.position + Vector2(Global.player_dir * 200, -20))
			stab_wave.set_speed(20, 0)
			stab_wave.set_lifetime(7)
			stab_wave.set_stuntime(45)
			stab_wave.set_ult_charge_amount(55)
			stab_wave.set_size(1)
			stab_wave.set_hitnum(10)
			get_tree().current_scene.get_node("Projectiles").add_child(stab_wave)
		
		if Global.attack1t == 35:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack1t >= 1:
		Global.attack1t += 1

	if Global.attack1t >= attack1_max_t:
		Global.attack1t = 0

func init_attack_2():
	if Global.stamina >= 60:
		set_dir()

		Global.stamina -= 60

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("paladin_cross")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 30:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.15)
		
		# spawns soul explosions
		if Global.attack2t == 20:
			var enemy_list = get_tree().current_scene.get_node("Enemies")
			if enemy_list.get_child_count() > 0:
				for i in range(enemy_list.get_child_count()):
					var target = enemy_list.get_child(i)
					if target.is_in_group("attackable") and target.is_in_group("enemy"):
						if Global.player_dir == -1 and target.position.x < player.position.x:
								target.inflict_fire(0.5 * Global.intellect)
								target.take_stun(30)
								var beam = preload("res://Scenes/Player/Classes/paladin/beam.tscn").instantiate()
								beam.position.x = target.position.x
								beam.position.y = -1000
								get_tree().current_scene.get_node("Projectiles").add_child(beam)
						elif Global.player_dir == 1 and target.position.x > player.position.x:
								target.inflict_fire(0.5 * Global.intellect)
								target.take_stun(30)
								var beam = preload("res://Scenes/Player/Classes/paladin/beam.tscn").instantiate()
								beam.position.x = target.position.x
								beam.position.y = -1000
								get_tree().current_scene.get_node("Projectiles").add_child(beam)
				
		if Global.attack2t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 55:
		set_dir()

		Global.stamina -= 55

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("paladin_shield")
		Global.attack3t = 1
		player.set_attacking(true)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 30:
		class_anim.speed_scale = 2.5
		player.set_speed_penalty(0.1)
		
		if Global.attack3t == 1:
			status.set_defensive_stance(3, 30)
		
		# spawns bash wave
		if Global.attack3t == 15:
			wave = preload("res://Scenes/Player/Classes/brawler/fist_shockwave.tscn").instantiate()
			wave.set_player(player)
			wave.set_damage(Global.power +Global.strength)
			wave.set_knockback(30)
			wave.set_pos(player.position)
			wave.set_speed(0, 0)
			wave.set_lifetime(10)
			wave.set_stuntime(75)
			wave.set_hitnum(10)
			wave.set_ult_charge_amount(55)
			wave.set_size(12.75)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)
			
		if between(Global.attack3t, 10, 15):
			if player.position.x > -950 and player.position.x < 950:
				if Global.player_dir == -1:
					player.position.x = maxi(player.position.x - (0.5 * Global.attack3t), -950)
				if Global.player_dir == 1:
					player.position.x = mini(player.position.x + (0.5 * Global.attack3t), 950)

		if between(Global.attack3t, 16, 21):
			if player.position.x > -950 and player.position.x < 950:
				if Global.player_dir == -1:
					player.position.x = maxi(player.position.x - 70, -950)
				if Global.player_dir == 1:
					player.position.x = mini(player.position.x + 70, 950)
				wave.set_pos(player.position + Vector2(Global.player_dir * 60, -85))
		
		if Global.attack3t == 21:
			player.velocity.x = Global.player_dir * 600
		
		if Global.attack3t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 75:
		set_dir()

		Global.stamina -= 75
		Global.attack4t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("paladin_slash")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 60:
		class_anim.speed_scale = 2.5
		player.set_speed_penalty(0.1)
		
		if Global.attack4t == 37:
			wave = preload("res://Scenes/Player/Classes/paladin/paladin_slice.tscn").instantiate()
			wave.set_player(player)
			if not status.get_borrowed_time():
				wave.set_damage(Global.power * 0.25 * (1 + 0.01 * status.get_retribution()))
				status.remove_retribution(status.get_retribution())
			else:
				wave.set_damage(Global.power * 0.25)
			wave.set_knockback(3.5, -1.5)
			wave.set_pos(player.position + Vector2(100 * Global.player_dir, -350))
			wave.set_speed(20, 0)
			wave.set_stuntime(30)
			wave.set_ult_charge_amount(5)
			wave.set_size(8)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)
			
		if Global.attack4t == 45:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack4t >= 1:
		Global.attack4t += 1

	if Global.attack4t >= attack4_max_t:
		Global.attack4t = 0

func init_attack_5():
	if Global.stamina >= 30:
		set_dir()

		Global.attack5t = 1
		Global.stamina -= 30
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("scream")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 30:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0)
		
		status.set_borrowed_time(600)
		
		if Global.attack5t >= 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack5t >= 1:
		Global.attack5t += 1

	if Global.attack5t >= attack5_max_t:
		Global.attack5t = 0

func init_ultimate():
	if Global.stamina >= 0:
		set_dir()

		Global.stamina -= 0
		Global.ultimatet = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("swipe_2")
		Global.ultimatet = 1
		player.set_attacking(true)

func ultimate():
	if Global.ultimatet >= 1 and Global.ultimatet <= 55:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0)
		
		# activates the river styx buff
		if Global.ultimatet == 40:
			if Global.Souls > 0:
				var amount = mini(Global.Souls, 2)
				status.add_river(amount * 420)
				Global.Souls -= amount
				status.start_river(600 + amount * 210)
			else:
				status.start_river(600)
			used_styx_souls = 0

		if Global.ultimatet == 41:
			Global.ultimate_charge = 0
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.ultimatet >= 1:
		Global.ultimatet += 1

	if Global.ultimatet >= ultimate_max_t:
		Global.ultimatet = 0

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
		ultimate()
