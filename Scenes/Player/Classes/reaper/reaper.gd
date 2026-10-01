extends Node2D

var attack1_max_t = 90
var attack2_max_t = 240
var attack3_max_t = 300
var attack4_max_t = 720
var attack5_max_t = 31
var ultimate_max_t = 90

var active = false

var explosion
var soul_needle
var reaper_slice
var descriptions 
var closest_enemy

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../../Non Attached UI Elements/Status_effects"

var explosion_preload = preload("res://Scenes/Player/Classes/reaper/explosion.tscn")
var soul_needle_preload = preload("res://Scenes/Player/Classes/reaper/soul_needle.tscn")
var giant_fist_preload = preload("res://Scenes/Player/Classes/brawler/giant_fist.tscn")
var reaper_slice_preload = preload("res://Scenes/Player/Classes/reaper/reaper_slice.tscn")

var used_styx_souls = 0
var total_targets

func get_description():
	descriptions = {
	"attack_1": ["[b]Soul explosion[/b]\n", "Sends out a soul fragment that causes a small explosion dealing heavy damage at a moderate range.\n[color=dodger_blue]Consumes 45 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + 0.75x intellect + 0.25x dexterity)\n" % (Global.power + (0.75 * Global.intellect) + (0.25 * Global.dexterity)), "Cooldown: %.2fs\n" % (float(attack1_max_t)/60), "Knockback: 5\n", "Stuntime: 0.5s\n"],
	"attack_2": ["[b]Recursive Bombs[/b]\n", "Fires out a row of soul fragments each slightly bigger than the previous and each explosion deals 8% more damage than the previous. Explosions flings enemies up.\n[color=dodger_blue]Consumes 80 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color]+8%%(i) x5 (50%% + 0.5x intellect)x5\n" % ((0.5 * Global.power) + (0.5 * Global.intellect)),"Cooldown: %.2fs\n" % (float(attack2_max_t)/60), "Knockback: 5 x5\n", "Stuntime: 1s\n"],
	"attack_3": ["[b]Soul needles[/b]\n", "Summons needles above your character which propels themselves into enemies and constantly do damage and inflict stun once they land. More needles are summoned based on enemy count.\n[color=dodger_blue]Consumes 75 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (10%% +  0.1x intellect)\n" % ((0.1 * Global.power) + (0.1 * Global.intellect)),"Cooldown: %.2fs\n" % (float(attack3_max_t)/60), "Knockback: 0\n", "Stuntime: 0.16s\n\n", "Inflicts [color=gray]Deathmark 25[/color]"],
	"attack_4": ["[b]Reap[/b]\n", "Jumps towards the direction you're facing and summons a scythe to perform a soul slice. Enemies hit by the soul slice spawns 4 soul explosions each doing 50% of this attack's damage.\n[color=dodger_blue]Consumes 120 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + 0.5x intellect + 0.75x dexterity)\n" % (Global.power + (0.5 * Global.intellect) + (0.75 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack4_max_t)/60), "Knockback: 0\n", "Stuntime: 0.5s"],
	"attack_5": ["[b]Recover[/b]\n", "Reduces all skills cooldowns by 0.33s and recover 20 stamina per use. If river styx is active, then consume a soul to add 3s to it up to 5 times.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]0[/color] (0)\n", "Cooldown: %.2fs\n" % (float(attack5_max_t)/60), "Knockback: 0\n", "Stuntime: 0s\n\n"],
	"ultimate": ["[b]River Styx[/b]\n", "Spawns an area that heals 4hp/s and summons skulls who frequently casts soul explosions to a random mob for 10s. Consumes up to 2 Souls to increase time by 3.5s each.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%%)\n" % Global.power, "Cooldown: %.2fs\n" % (float(ultimate_max_t)/60), "Knockback: 0\n", "Stuntime: 0s\n"],
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
		class_anim.play("punch")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 24:
		class_anim.speed_scale = 4
		player.set_speed_penalty(0.25)
		
		# spawns wave
		if Global.attack1t == 12:
			explosion = explosion_preload.instantiate()
			explosion.set_player(player)
			explosion.set_damage(Global.power + (0.75 * Global.intellect) + (0.25 * Global.dexterity))
			explosion.set_knockback(5)
			explosion.set_pos(player.position + Vector2(15 * Global.player_dir, -60))
			explosion.set_speed(20, 0)
			explosion.set_lifetime(50)
			explosion.set_stuntime(30)
			explosion.set_ult_charge_amount(55)
			explosion.set_size(5)
			explosion.set_hitnum(100)
			get_tree().current_scene.get_node("Projectiles").add_child(explosion)

		if Global.attack1t == 24:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack1t >= 1:
		Global.attack1t += 1

	if Global.attack1t >= attack1_max_t:
		Global.attack1t = 0

func init_attack_2():
	if Global.stamina >= 80:
		set_dir()

		Global.stamina -= 80

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("punch")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 34:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.15)
		
		# spawns wave
		if between(Global.attack2t, 16, 34) and Global.attack2t % 4 == 0:
			explosion = explosion_preload.instantiate()
			explosion.set_player(player)
			explosion.set_damage((0.5 * Global.power + 0.5 * Global.intellect) * (1 + 0.02 * (Global.attack2t-16)))
			explosion.set_knockback(5, -7)
			explosion.set_pos(player.position + Vector2(15 * Global.player_dir, -60))
			explosion.set_speed(1 + 8 * (Global.attack2t-16), 0)
			explosion.set_lifetime(50)
			explosion.set_stuntime(30)
			explosion.set_ult_charge_amount(40)
			explosion.set_size(2.25 + 0.75 * (Global.attack2t-16))
			explosion.set_hitnum(100)
			get_tree().current_scene.get_node("Projectiles").add_child(explosion)

		if Global.attack2t == 34:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 75:
		set_dir()

		Global.stamina -= 75

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("spike")
		Global.attack3t = 1
		player.set_attacking(true)
		
		total_targets = maxi(5-get_tree().current_scene.get_node("Enemies").get_child_count(), 2)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 20:
		class_anim.speed_scale = 2.5
		player.set_speed_penalty(0.1)
		
		# spawns wave
		if between(Global.attack3t, 1, 20) and Global.attack3t % total_targets == 0:
			soul_needle = soul_needle_preload.instantiate()
			soul_needle.set_player(player)
			soul_needle.set_damage(0.1 * Global.power + 0.1 * Global.intellect)
			soul_needle.set_knockback(5)
			soul_needle.set_pos(player.position + Vector2(-1800 + (150 * Global.attack3t), -1200))
			soul_needle.set_lifetime(60)
			soul_needle.set_stuntime(10)
			soul_needle.set_ult_charge_amount(3)
			soul_needle.set_size(3)
			soul_needle.set_hitnum(100)
			get_tree().current_scene.get_node("Projectiles").add_child(soul_needle)

		if Global.attack3t == 20:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 120:
		set_dir()

		Global.stamina -= 120
		Global.attack4t = 1

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("swipe")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 60:
		class_anim.speed_scale = 2.6
		player.set_speed_penalty(0.1)
		
		if Global.attack4t == 10:
			player.velocity.x = 1000 * Global.player_dir
			if player.is_on_floor():
				player.velocity.y -= 1000
		
		if between(Global.attack4t, 10, 13):
			if player.position.x + 60 < 1000 and player.position.x - 60 > -1000:
				player.position.x += 60 * Global.player_dir
		
		# spawns wave
		if Global.attack4t == 30:
			reaper_slice = reaper_slice_preload.instantiate()
			reaper_slice.set_player(player)
			reaper_slice.set_damage(Global.power + (0.5 * Global.intellect) + (0.75 * Global.dexterity))
			reaper_slice.set_knockback(5)
			reaper_slice.set_pos(player.position + Vector2(15 * Global.player_dir, -60))
			reaper_slice.set_speed(30, 0)
			reaper_slice.set_lifetime(40)
			reaper_slice.set_stuntime(25)
			reaper_slice.set_ult_charge_amount(95)
			reaper_slice.set_size(2)
			reaper_slice.set_hitnum(100)
			get_tree().current_scene.get_node("Projectiles").add_child(reaper_slice)

		if Global.attack4t == 40:
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
		class_anim.play("recover")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 30:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0)
		
		player.gain_stamina(1)
		
		if Global.attack1t != 0:
			Global.attack1t += 1
		if Global.attack2t != 0:
			Global.attack2t += 1
		if Global.attack3t != 0:
			Global.attack3t += 1
		if Global.attack4t != 0:
			Global.attack4t += 1
			
		if Global.attack5t == 10 and used_styx_souls < 5:
			if status.get_river() and Global.Souls > 0:
				status.add_river(240)
				Global.Souls -= 1
		
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
		
		# spawns wave
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
