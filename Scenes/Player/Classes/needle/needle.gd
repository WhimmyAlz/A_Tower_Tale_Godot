extends Node2D

var attack1_max_t = 15
var attack2_max_t = 120
var attack3_max_t = 180
var attack4_max_t = 600
var attack5_max_t = 480
var ultimate_max_t = 15

var active = false

var needle_stacks = 0
var needle
var wave

var descriptions 

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../Status_effects"

var fist_wave = preload("res://Scenes/Player/Classes/brawler/fist_shockwave.tscn")
var needle_proj = preload("res://Scenes/Player/Classes/needle/needle_proj.tscn")


func get_description():
	descriptions = {
	"attack_1": ["[b]Jab[/b]\n", "A quick stab using a needle at a long melee range. Successful attacks gives you a needle stack. \nHas a 1 in 3 chance to perform a slice. \n[color=dodger_blue]Consumes 15 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (25%% + 0.5x dexterity)\n" % ((0.25 * Global.power) + (0.5 * Global.dexterity)), "Cooldown: %.1fs\n" % (float(attack1_max_t)/60), "Knockback: 2\n", "Stuntime: 0.1s\n\n", "Slice: deals 5 damage, ignores 10 defense, inflicts [color=red]bleed 1[/color], and gain 1 needle stack\n\n", "Has a 20% chance to inflict [color=red]bleed 1[/color]\n"],
	"attack_2": ["[b]Needle storm[/b]\n", "Throws out 2-7 needles based on amount of needle stacks you have. Needles have long range and quick speed. \nHas a 1 in 2 chance to perform a slice. \n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] x2-7 (0.25%% + 0.5x dexterity)x2-7\n" % ((0.25 * Global.power) + (0.5 * Global.dexterity)),"Cooldown: %.1fs\n" % (float(attack2_max_t)/60), "Knockback: 2 x2-7\n", "Stuntime: 0.25s\n\n", "Slice: deals 5 damage, ignores 10 defense, and inflicts [color=red]bleed 1[/color]\n\n", "Has a 60% chance to inflict [color=red]bleed 1[/color]"],
	"attack_3": ["[b]Venom pins[/b]\n", "Throws two needles which deals abysmal damage, but inflicts heavy venom. Needles have increased piercing based on needle stacks. \n[color=dodger_blue]Consumes 30 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (10%% + 0.1x dexterity)x2\n" % ((0.1 * Global.power) + (0.1 * Global.dexterity)),"Cooldown: %.1fs\n" % (float(attack3_max_t)/60), "Knockback: 2 x2\n", "Stuntime: 0.25s\n\n", "Inflicts [color=purple]venom 6[/color]"],
	"attack_4": ["[b]Vex[/b]\n", "Shoots a piercing needle that performs slices as it travels. \n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + dexterity)\n" % (Global.power + Global.dexterity),"Cooldown: %.1fs\n" % (float(attack4_max_t)/60), "Knockback: 2\n", "Stuntime: 0.25s\n\n", "Slice: deals 5 damage, ignores 10 defense, inflicts [color=red]bleed 1[/color], and gain 10% max stamina or 1 needle stack if stamina is full"],
	"attack_5": ["[b]Needle therapy[/b]\n", "Throws out a burst of 20 needles in a wide angle each dealing low damage but inflicting shock. Consumes needle stacks to make the angle narrower.\n[color=dodger_blue]Consumes 70 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (10%% + 0.1x dexterity)\n" % (0.1 * Global.power + 0.1 * Global.dexterity), "Cooldown: %.1fs\n" % (float(attack5_max_t)/60), "Knockback: 0\n", "Stuntime: 0.33s\n\n", "Inflicts [color=yellow]shock 20[/color]"],
	"ultimate": ["[b]Vein cutter[/b]\n", "Quickly dashes forwards while holding out a giant needle infront of you which performs slices on the needle's end. Might hit multiple times.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (200%% + 4x dexterity)\n" % ((2 * Global.power) + (4 * Global.dexterity)), "Cooldown: %.1fs\n" % (float(ultimate_max_t)/60), "Knockback: 50\n", "Stuntime: 1s\n\n", "Slice: deals 10 damage, ignores 10 defense, and inflicts [color=red]bleed 1[/color], and gain 1 needle stack"],
	}
	return(descriptions)

func set_dir():
	if Global.player_dir == -1:
		class_anim.flip_h = true
	else:
		class_anim.flip_h = false

func add_needle_stacks(amount):
	if needle_stacks < 5:
		needle_stacks = mini(needle_stacks + amount, 5)

func init_attack_1():
	if Global.stamina >= 15:
		set_dir()

		Global.stamina -= 15
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("spike")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 10:
		class_anim.speed_scale = 5
		player.set_speed_penalty(0.5)
		
		# spawns needle
		if Global.attack1t == 1:
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((0.25 * Global.power) + (0.5 * Global.dexterity))
			needle.set_knockback(2)
			needle.set_pos(player.position + Vector2(10 * Global.player_dir, -35))
			needle.set_speed(30, 0)
			needle.set_size(1.2)
			needle.set_stuntime(6)
			needle.set_ult_charge_amount(20)
			needle.set_bleed_chance(20)
			needle.needle_stacks(1)

			if randi_range(0,2) == 0:
				needle.set_slices(true)

			get_tree().current_scene.get_node("Projectiles").add_child(needle)

		if Global.attack1t == 10:
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
		class_anim.play("spike")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 25:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.5)
		
		# spawns needle
		if between(Global.attack2t, 1, 2 + needle_stacks):
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((0.25 * Global.power) + (0.5 * Global.dexterity))
			needle.set_knockback(2)
			needle.set_pos(player.position + Vector2(10 * Global.player_dir, -80 + Global.attack2t * 10))
			needle.set_speed(60, 0)
			needle.set_size(1.5)
			needle.set_ult_charge_amount(30)
			needle.set_stuntime(15)
			needle.set_lifetime(18)
			needle.set_bleed_chance(60)
			
			if randi_range(0,1) == 0:
				needle.set_slices(true)
			
			get_tree().current_scene.get_node("Projectiles").add_child(needle)

		if Global.attack2t == 25:
			needle_stacks = 0
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 30:
		set_dir()

		Global.stamina -= 30
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("spike")
		Global.attack3t = 1
		player.set_attacking(true)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 20:
		class_anim.speed_scale = 7
		player.set_speed_penalty(0.5)
		
		# spawns needle
		if between(Global.attack3t, 1, 10) and Global.attack3t % 5 == 0:
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((0.1 * Global.power) + (0.1 * Global.dexterity))
			needle.set_knockback(2)
			needle.set_pos(player.position + Vector2(10 * Global.player_dir, -40))
			needle.set_speed(100, 0)
			needle.set_size(1.5)
			needle.set_venom(6)
			needle.set_hitnum(1 + needle_stacks)
			needle.set_ult_charge_amount(40)
			needle.set_stuntime(15)
			needle.set_lifetime(20)
			needle.set_bleed_chance(60)
			get_tree().current_scene.get_node("Projectiles").add_child(needle)

		if Global.attack3t == 20:
			needle_stacks = 0
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 0:
		set_dir()

		Global.stamina -= 0
		Global.attack4t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("spike")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 20:
		class_anim.speed_scale = 4
		player.set_speed_penalty(0.5)
		
		# spawns needle
		if Global.attack4t == 1:
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((1 * Global.power) + (1 * Global.dexterity))
			needle.set_knockback(2)
			needle.set_pos(player.position + Vector2(10 * Global.player_dir, -40))
			needle.set_speed(100, 0)
			needle.set_size(1.5)
			needle.set_slicer(true)
			needle.set_vex_regen(true)
			needle.set_hitnum(5)
			needle.set_ult_charge_amount(100)
			needle.set_stuntime(15)
			needle.set_lifetime(20)
			get_tree().current_scene.get_node("Projectiles").add_child(needle)

		if Global.attack4t == 20:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack4t >= 1:
		Global.attack4t += 1

	if Global.attack4t >= attack4_max_t:
		Global.attack4t = 0

func init_attack_5():
	if Global.stamina >= 70:
		set_dir()

		Global.stamina -= 70
		Global.attack5t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("spike")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 20:
		class_anim.speed_scale = 4
		player.set_speed_penalty(0.5)
		
		var v_speed = randi_range(-80 + (12 * needle_stacks), 80 - (12 * needle_stacks))
		
		# spawns needle
		if between(Global.attack5t, 1, 20):
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((0.1 * Global.power) + (0.1 * Global.dexterity))
			needle.set_knockback(0)
			needle.set_pos(player.position + Vector2(5 * Global.player_dir * Global.attack5t, -40))
			needle.set_speed(60, v_speed)
			needle.set_angle(v_speed * Global.player_dir * 0.0125)
			needle.set_size(1.5)
			needle.set_hitnum(1)
			needle.set_stuntime(20)
			needle.set_ult_charge_amount(6)
			needle.set_shock(20)
			needle.set_lifetime(20)
			get_tree().current_scene.get_node("Projectiles").add_child(needle)

		if Global.attack5t == 20:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)
			needle_stacks = 0

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
		class_anim.play("punch")
		class_anim.frame = 5
		class_anim.pause()
		Global.ultimatet = 1
		player.set_attacking(true)

func ultimate():
	if Global.ultimatet >= 1 and Global.ultimatet <= 10:
		class_anim.speed_scale = 2
		player.set_speed_penalty(0)
		
		# spawns wave
		if Global.ultimatet == 1:
			needle = needle_proj.instantiate()
			needle.set_player(player)
			needle.set_damage((2 * Global.power) + (4 * Global.dexterity))
			needle.set_pos(player.position + Vector2(150 * Global.player_dir, -85))
			needle.set_stuntime(60)
			needle.set_hitnum(100)
			needle.set_lifetime(15)
			needle.set_slicer(true)
			needle.set_size(3.25)
			needle.set_knockback(50)
			needle.set_ult_charge_amount(0)
			get_tree().current_scene.get_node("Projectiles").add_child(needle)
		
		if between(Global.ultimatet, 2, 10):
			needle.set_pos(player.position + Vector2(250 * Global.player_dir, -85))
			player.velocity.x = Global.player_dir * 6400
		
		if Global.ultimatet == 10:
			player.velocity.x = 0
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
