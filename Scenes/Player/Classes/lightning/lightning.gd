extends Node2D

var attack1_max_t = 75
var attack2_max_t = 60
var attack3_max_t = 210
var attack4_max_t = 450
var attack5_max_t = 600
var ultimate_max_t = 60

var active = false

var bullet

var gun
var scope
var descriptions 

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills
@onready var status = $"../../../Non Attached UI Elements/Status_effects"

var bullet_proj = preload("res://Scenes/Player/Classes/deadeye/bullet.tscn")
var gun_preload = preload("res://Scenes/Player/Classes/deadeye/gun.tscn")
var scope_preload = preload("res://Scenes/Player/Classes/deadeye/scope.tscn")

var zap
var zap_preload = preload("res://Scenes/Player/Classes/lightning/zap.tscn")
var lightning_dash_preload = preload("res://Scenes/Player/Classes/lightning/lightning_dash.tscn")
var smite_preload = preload("res://Scenes/Player/Classes/lightning/smite.tscn")
var one_shot

func get_description():
	descriptions = {
	"attack_1": ["[b]Zap[/b]\n", "Shoots a bolt of lightning that deals moderate damage. Deals more damage if the bolt travels less distance. (up to 150%% damage) \n[color=dodger_blue]Consumes 25 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (40%% + 0.4x intellect)\n" % ((0.4 * Global.power) + (0.4 * Global.intellect)), "Cooldown: %.2fs\n" % (float(attack1_max_t)/60), "Knockback: 0\n", "Stuntime: 0.2s\n\n", "Inflicts [color=yellow]Shock 5[/color]"],
	"attack_2": ["[b]Lightning Dash[/b]\n", "Teleports to the furthest enemy you are facing. Deals small amounts of damage to everyone that you pass through. \n[color=dodger_blue]Consumes 45 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (20%% + 0.5x dexterity)\n" % ((0.2 * Global.power) + (0.5 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack2_max_t)/60), "Knockback: 0\n", "Stuntime: 0.4s\n\n", "Inflicts [color=yellow]Shock 10[/color]"],
	"attack_3": ["[b]Thunder Smite[/b]\n", "Slams a lightning bolt into the ground dealing heavy aoe damage.\n[color=dodger_blue]Consumes 65 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (100%% + 0.75x intellect)\n" % ((1 * Global.power) + (0.75 * Global.intellect)),"Cooldown: %.2fs\n" % (float(attack3_max_t)/60), "Knockback: 0\n", "Stuntime: 0.5s\n\n", "Inflicts [color=yellow]Shock 40[/color]"],
	"attack_4": ["[b]Cover Me![/b]\n", "Calls for cover fire. 3 special shots are fired at random enemies, piercing them and inflicting fire. \n[color=dodger_blue]Consumes 60 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (60%% + 0.6x dexterity)x3\n" % ((0.6 * Global.power) + (0.6 * Global.dexterity)),"Cooldown: %.2fs\n" % (float(attack4_max_t)/60), "Knockback: 0\n", "Stuntime: 0.2s\n\n", "Inflicts [color=orange]Fire 9[/color]\n"],
	"attack_5": ["[b]Gun Boomerang[/b]\n", "Throw a revolver which spins forward before flying back while rapidly firing bullets. \n[color=dodger_blue]Consumes 75 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (30%% + 0.3x dexterity)\n" % (0.3 * Global.power + 0.3 * Global.dexterity), "Cooldown: %.2fs\n" % (float(attack5_max_t)/60), "Knockback: 5\n", "Stuntime: 0.25s\n"],
	"ultimate": ["[b]Big Bill[/b]\n", "Charges up a massive bullet that rips through enemies whilst inflicting heavy burn.\n[color=dodger_blue]Consumes 0 stamina.[/color]\n\n", "Damage: [color=red]%.1f[/color] (350%% + 3.5x dexterity)\n" % ((3.5 * Global.power) + (3.5 * Global.dexterity)), "Cooldown: %.2fs\n" % (float(ultimate_max_t)/60), "Knockback: 10\n", "Stuntime: 1.5s\n\n", "Inflicts [color=orange]Fire 30[/color], crits inflict [color=yellow]Shock 50[/color]"],
	}
	return(descriptions)

func set_dir():
	if Global.player_dir == -1:
		class_anim.flip_h = true
	else:
		class_anim.flip_h = false

func init_attack_1():
	if Global.stamina >= 25:
		set_dir()

		Global.stamina -= 25
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("base_shock")
		Global.attack1t = 1
		player.set_attacking(true)

func attack_1():
	if Global.attack1t >= 1 and Global.attack1t <= 15:
		class_anim.speed_scale = 4.75
		player.set_speed_penalty(0.15)
		
		# spawns bullet
		if Global.attack1t == 7:
			zap = zap_preload.instantiate()
			zap.set_player(player)
			zap.set_damage((0.4 * Global.power) + (0.4 * Global.intellect))
			zap.set_knockback(0)
			zap.set_pos(player.position + Vector2(400 * Global.player_dir, -70))
			zap.set_stuntime(12)
			zap.set_size(5)
			zap.set_lifetime(18)
			zap.set_hitnum(5)
			zap.set_ult_charge_amount(35)

			get_tree().current_scene.get_node("Projectiles").add_child(zap)

		if Global.attack1t == 15:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack1t >= 1:
		Global.attack1t += 1

	if Global.attack1t >= attack1_max_t:
		Global.attack1t = 0

func init_attack_2():
	if Global.stamina >= 45:
		set_dir()

		Global.stamina -= 45
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("lightning_shift")
		Global.attack2t = 1
		player.set_attacking(true)

func attack_2():
	if Global.attack2t >= 1 and Global.attack2t <= 6:
		class_anim.speed_scale = 10
		player.set_speed_penalty(0.5)
		
		# spawns needles
		if Global.attack2t == 1:
			
			var enemy_list = get_tree().current_scene.get_node("Enemies")
			if enemy_list.get_child_count() > 0:
				for i in range(enemy_list.get_child_count()):
					var target = enemy_list.get_child(i)
					var final_target = null
					if target.is_in_group("attackable") and target.is_in_group("enemy"):
						if Global.player_dir == -1 and target.position.x < player.position.x:
								if final_target == null or (target.position.x < final_target.position.x and abs(target.position.x) < 1000):
									final_target = target
						elif Global.player_dir == 1 and target.position.x > player.position.x:
								if final_target == null or (target.position.x > final_target.position.x and abs(target.position.x) < 1000):
									final_target = target
					if final_target != null:
						zap = lightning_dash_preload.instantiate()
						zap.set_player(player)
						zap.set_damage((0.2 * Global.power) + (0.5 * Global.dexterity))
						zap.change_scale((abs(player.position.x - final_target.position.x))/2000)
						zap.set_size(9)
						zap.set_target(final_target)
						zap.set_knockback(0)
						zap.set_pos(player.position + Vector2(1200 * Global.player_dir, 0))
						zap.set_stuntime(24)
						zap.set_lifetime(30)
						zap.set_hitnum(100)
						zap.set_ult_charge_amount(40)
						status.set_iframes(12)

						get_tree().current_scene.get_node("Projectiles").add_child(zap)
						player.position.x = final_target.position.x - (Global.player_dir * 50)

		if Global.attack2t == 6:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack2t >= 1:
		Global.attack2t += 1

	if Global.attack2t >= attack2_max_t:
		Global.attack2t = 0

func init_attack_3():
	if Global.stamina >= 65:
		set_dir()

		Global.stamina -= 65
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("lightning_throw")
		Global.attack3t = 1
		player.set_attacking(true)

func attack_3():
	if Global.attack3t >= 1 and Global.attack3t <= 21:
		class_anim.speed_scale = 3.5
		player.set_speed_penalty(0.05)
		
		if between(Global.attack3t, 1, 9):
			player.position.y = maxi(player.position.y - 40, -700)
			player.velocity.y = 0
			one_shot = true
		if between(Global.attack3t, 10, 19):
			if player.position.y < 785:
				player.position.y = mini(player.position.y + 300, 789)
				player.velocity.y = 0
			elif one_shot:
				zap = smite_preload.instantiate()
				zap.set_player(player)
				zap.set_damage((1 * Global.power) + (0.75 * Global.intellect))
				zap.set_knockback(0)
				zap.set_pos(player.position + Vector2(100 * Global.player_dir, -320))
				zap.set_stuntime(30)
				zap.set_size(5)
				zap.set_lifetime(25)
				zap.set_hitnum(100)
				zap.set_ult_charge_amount(75)

				get_tree().current_scene.get_node("Projectiles").add_child(zap)
				one_shot = false
				
		if Global.attack3t == 21:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack3t >= 1:
		Global.attack3t += 1

	if Global.attack3t >= attack3_max_t:
		Global.attack3t = 0

func init_attack_4():
	if Global.stamina >= 60:
		set_dir()

		Global.stamina -= 60
		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("base_talk")
		Global.attack4t = 1
		player.set_attacking(true)

func attack_4():
	if Global.attack4t >= 1 and Global.attack4t <= 30:
		class_anim.speed_scale = 3
		player.set_speed_penalty(0.1)
		
		# spawns venom needles
		if between(Global.attack4t, 1, 15) and Global.attack4t % 5 == 0:
			
			var enemy_list = get_tree().current_scene.get_node("Enemies")
			if enemy_list.get_child_count() > 0:
			
				scope = scope_preload.instantiate()
				scope.set_player(player)
				scope.set_target(enemy_list.get_child(randi_range(0, enemy_list.get_child_count()-1)))
				scope.set_damage((0.6 * Global.power) + (0.6 * Global.dexterity))

				get_tree().current_scene.get_node("Projectiles").add_child(scope)

		if Global.attack4t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

	if Global.attack4t >= 1:
		Global.attack4t += 1

	if Global.attack4t >= attack4_max_t:
		Global.attack4t = 0

func init_attack_5():
	if Global.stamina >= 75:
		set_dir()

		Global.stamina -= 75

		player.set_animation_visibility(false)
		class_anim.visible = true
		class_anim.frame = 0
		class_anim.play("gun_throw")
		Global.attack5t = 1
		player.set_attacking(true)

func attack_5():
	if Global.attack5t >= 1 and Global.attack5t <= 20:
		class_anim.speed_scale = 2.75
		player.set_speed_penalty(0)
		
		# spawns spikes
		if Global.attack5t == 5:
			gun = gun_preload.instantiate()
			gun.set_player(player)
			gun.set_pos(player.position + Vector2(0, -80))
			gun.set_speed(Vector2(25, 0))
			gun.set_damage((0.3 * Global.power) + (0.3 * Global.dexterity))

			get_tree().current_scene.get_node("Projectiles").add_child(gun)

		if Global.attack5t == 20:
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
		class_anim.play("long_shoot")
		player.set_attacking(true)

func ultimate():
	if Global.ultimatet >= 1 and Global.ultimatet <= 45:
		class_anim.speed_scale = 2
		player.set_speed_penalty(0)
		
		# spawns needle blade
		if Global.ultimatet == 30:
			bullet = bullet_proj.instantiate()
			bullet.set_player(player)
			bullet.set_damage((3.5 * Global.power) + (3.5 * Global.dexterity))
			bullet.set_knockback(10)
			bullet.set_pos(player.position + Vector2(100 * Global.player_dir, randi_range(-102, -98)))
			bullet.set_stuntime(90)
			bullet.set_hitnum(100)
			bullet.set_speed(190, 0)
			bullet.set_lifetime(30)
			bullet.set_size(14)
			bullet.set_mega_shot(true)
			bullet.set_ult_charge_amount(0)

			get_tree().current_scene.get_node("Projectiles").add_child(bullet)

		if Global.ultimatet == 45:
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
