extends Node2D

var attack1_max_t = 25
var attack2_max_t = 150
var attack3_max_t = 240
var attack4_max_t = 300
var attack5_max_t = 450
var ultimate_max_t = 60

var active = false

var consumed_needle_stacks = 0
var needle

var shadow_spike
var shadow_break
var descriptions 

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../../Non Attached UI Elements/Status_effects"

var needle_proj = preload("res://Scenes/Player/Classes/needle/needle_proj.tscn")
var shadow_spike_proj = preload("res://Scenes/Player/Classes/shadow/shadow_spike.tscn")
var shadow_break_preload = preload("res://Scenes/Player/Classes/shadow/shadow_break.tscn")
var shadow_slice = preload("res://Scenes/Player/Classes/shadow/shadow_slice.tscn")

func get_description():
	descriptions = {
	"attack_1": ["[b]Shadow Spike[/b]\n", "Quickly shoots out 4 spikes at moderate range. Each consecutive spike reaches a bit further. \n[color=dodger_blue]Consumes 20 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] x4 (15%% + 0.15x dexterity)x4\n" % ((0.15 * Global.power) + (0.15 * Global.dexterity)), "Cooldown: %.2fs\n" % (float(attack1_max_t)/60), "Knockback: 2 x4\n", "Stuntime: 0.16s\n"],
	"attack_2": ["[b]Shadow Shift[/b]\n", "Shifts a moderate distance forward, granting iframes, and dealing damage to everything that you pass through. Also inflicts shock.\n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + 0.75x dexterity)\n" % ((1 * Global.power) + (0.75 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack2_max_t)/60), "Knockback: 2\n", "Stuntime: 1.5s\n\n", "Inflicts [color=yellow]shock 75[/color]"],
	"attack_3": ["[b]Spike Eruption[/b]\n", "Sends outs rows of shadow spikes from the ground around you. Flings enemies into the air.\n[color=dodger_blue]Consumes 50 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (50%% + 0.5x dexterity)\n" % ((0.5 * Global.power) + (0.5 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack3_max_t)/60), "Knockback: 0\n", "Stuntime: 1.0s\n"],
	"attack_4": ["[b]Clones[/b]\n", "Summons 2 clones that help attack for you. Damage is based on first skill. Clones can't crit. \n[color=dodger_blue]Consumes 100 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (15%% + 0.15x dexterity)x2\n" % ((0.15 * Global.power) + (0.15 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack4_max_t)/60), "Knockback: 2\n", "Stuntime: 0.05s\n"],
	"attack_5": ["[b]Giant Spikes[/b]\n", "Shoots out 3 giant shadow spikes, dealing massive damage and has far reach.\n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (80%% + 0.5x dexterity)\n" % (0.8 * Global.power + 0.5 * Global.dexterity), "Cooldown: %.2fs\n" % (float(attack5_max_t)/60), "Knockback: 8\n", "Stuntime: 0.5s\n"],
	"ultimate": ["[b]Shadow Slices[/b]\n", "Quickly slices 3 times around you and deal massive damage. Crits inflict deathmark.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (60%% + 0.6x dexterity)\n" % ((0.6 * Global.power) + (0.6 * Global.dexterity)), "Cooldown: %.2fs\n" % (float(ultimate_max_t)/60), "Knockback: 0\n", "Stuntime: 1s\n\n", "Inflicts [color=yellow]Shock 15[/color] and crits inflict [color=gray]Deathmark 500[/color]"],
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
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("summon")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 12:
		class_anim.speed_scale = 4.5
		player.set_speed_penalty(0.25)
		
		# spawns needle
		if between(Global.attack1t, 1, 4):
			shadow_spike = shadow_spike_proj.instantiate()
			shadow_spike.set_player(player)
			shadow_spike.set_damage((0.15 * Global.power) + (0.15 * Global.dexterity))
			shadow_spike.set_knockback(2)
			shadow_spike.set_pos(player.position + Vector2((35 * (Global.attack1t-1) + 235) * Global.player_dir, -80))
			shadow_spike.set_size(0.5 * (Global.attack1t-1)+1)
			shadow_spike.set_stuntime(10)
			shadow_spike.set_rotate_level(1)
			shadow_spike.set_ult_charge_amount(15)

			get_tree().current_scene.get_node("Projectiles").add_child(shadow_spike)

		if Global.attack1t == 12:
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
		class_anim.play("shift")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 25:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.5)
		
		# spawns needles
		if Global.attack2t == 5:
			status.set_iframes(30)
			
			shadow_break = shadow_break_preload.instantiate()
			shadow_break.set_player(player)
			shadow_break.set_damage((1 * Global.power) + (0.75 * Global.dexterity))
			shadow_break.set_knockback(2)
			shadow_break.set_pos(player.position + Vector2(10 * Global.player_dir, -40))
			shadow_break.set_speed(100, 0)
			shadow_break.set_size(1.5)
			shadow_break.set_hitnum(10)
			shadow_break.set_ult_charge_amount(120)
			shadow_break.set_stuntime(90)
			get_tree().current_scene.get_node("Projectiles").add_child(shadow_break)

			if player.position.x > -1000 and player.position.x < 1000:
				if Global.player_dir == -1:
					player.position.x = maxi(player.position.x - (500), -999)
				if Global.player_dir == 1:
					player.position.x = mini(player.position.x + (500), 999)

		if Global.attack2t == 25:
			status.remove_needles(consumed_needle_stacks)
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 50:
		set_dir()

		Global.stamina -= 50
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("summon")
		Global.attack3t = 1
		player.set_attacking(true)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 20:
		class_anim.speed_scale = 3.5
		player.set_speed_penalty(0.15)

		# spawns slicer needle
		if between(Global.attack3t, 1, 9) and Global.attack3t % 3 == 0:
			shadow_spike = shadow_spike_proj.instantiate()
			shadow_spike.set_player(player)
			shadow_spike.set_damage((0.5 * Global.power) + (0.5 * Global.dexterity))
			shadow_spike.set_knockback(0, -11)
			shadow_spike.set_pos(player.position + Vector2(Global.player_dir * (75 + (Global.attack3t-3) * 60), -180))
			shadow_spike.set_size(2.5)
			shadow_spike.set_stuntime(60)
			shadow_spike.set_hitnum(10)
			shadow_spike.set_rotate_level(3)
			shadow_spike.set_ult_charge_amount(65)
			get_tree().current_scene.get_node("Projectiles").add_child(shadow_spike)
			
			shadow_spike = shadow_spike_proj.instantiate()
			shadow_spike.set_player(player)
			shadow_spike.set_damage((0.75 * Global.power) + (0.5 * Global.dexterity))
			shadow_spike.set_knockback(0, -11)
			shadow_spike.set_pos(player.position + Vector2(-Global.player_dir * (75 + (Global.attack3t-3) * 60), -180))
			shadow_spike.set_size(2.5)
			shadow_spike.set_stuntime(60)
			shadow_spike.set_hitnum(10)
			shadow_spike.set_rotate_level(3)
			shadow_spike.set_ult_charge_amount(60)
			get_tree().current_scene.get_node("Projectiles").add_child(shadow_spike)

		if Global.attack3t == 20:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 100:
		set_dir()

		Global.stamina -= 100
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("shift")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 20:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.5)
		
		# spawns venom needles
		if between(Global.attack4t, 1, 10) and Global.attack4t % 5 == 0:
			var clone = preload("res://Scenes/Player/Classes/shadow/shadow_clone.tscn").instantiate()
			clone.set_player(player)
			if Global.attack4t == 5:
				clone.set_dir(-1)
				clone.set_pos(player.position + Vector2(100, 0))
			else:
				clone.set_dir(1)
				clone.set_pos(player.position + Vector2(-100, 0))
			get_tree().current_scene.get_node("Projectiles").add_child(clone)

		if Global.attack4t == 20:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack4t >= 1:
		Global.attack4t += 1

	if Global.attack4t >= attack4_max_t:
		Global.attack4t = 0

func init_attack_5():
	if Global.stamina >= 60:
		set_dir()

		Global.stamina -= 60
		Global.attack5t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("rage")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 60:
		class_anim.speed_scale = 4
		player.set_speed_penalty(0)
		
		# spawns spikes
		if between(Global.attack5t, 16, 60) and Global.attack5t % 15 == 0:
			var extra_size = 0.5 * randi_range(0, 2)
			shadow_spike = shadow_spike_proj.instantiate()
			shadow_spike.set_player(player)
			shadow_spike.set_damage((0.8 * Global.power) + (0.5 * Global.dexterity))
			shadow_spike.set_knockback(8)
			shadow_spike.set_pos(player.position + Vector2(600 * Global.player_dir, -80))
			shadow_spike.set_size(4 + extra_size)
			shadow_spike.set_stuntime(30)
			shadow_spike.set_hitnum(10)
			shadow_spike.set_rotate_level(2)
			shadow_spike.set_giant_spike()
			shadow_spike.set_ult_charge_amount(60)
			player.get_parent().set_screenshake(3)
			

			get_tree().current_scene.get_node("Projectiles").add_child(shadow_spike)

		if Global.attack5t == 60:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)
			status.remove_needles(consumed_needle_stacks)

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
		class_anim.play("shift")
		Global.ultimatet = 1
		player.set_attacking(true)

func ultimate():
	if Global.ultimatet >= 1 and Global.ultimatet <= 45:
		class_anim.speed_scale = 4
		player.set_speed_penalty(0)
		
		# spawns needle blade
		if between(Global.ultimatet, 1, 30) and Global.ultimatet % 10 == 0:
			var slice = shadow_slice.instantiate()
			slice.set_player(player)
			slice.set_damage((0.6 * Global.power) + (0.6 * Global.dexterity))
			slice.set_pos(player.position + Vector2(150 * Global.player_dir, -70))
			slice.set_stuntime(60)
			slice.set_hitnum(100)
			slice.set_size(2)
			slice.set_knockback(0)
			if Global.ultimatet == 30:
				slice.set_angle(-60)
			else:
				slice.set_angle(6 * (Global.ultimatet - 10))
			slice.set_ult_charge_amount(0)
			get_tree().current_scene.get_node("Projectiles").add_child(slice)

		if Global.ultimatet == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)
			Global.ultimate_charge = 0

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
