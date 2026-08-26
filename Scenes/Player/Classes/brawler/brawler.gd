extends Node2D

var attack1_max_t = 60
var attack2_max_t = 100
var attack3_max_t = 1
var attack4_max_t = 1
var attack5_max_t = 1
var ultimate_max_t = 1

var wave

@onready var player = get_parent().get_parent()
@onready var class_anim = $skills

var fist_wave = preload("res://Scenes/Player/Classes/brawler/fist_shockwave.tscn")

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
	class_anim.speed_scale = 3
	
	if Global.attack1t >= 1:
		player.set_speed_penalty(0.25)
		
		Global.attack1t += 1
		
		# spawns wave
		if Global.attack1t == 20:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			wave.set_damage(25)
			wave.set_pos(player.position)
			wave.set_speed(0, 0)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if between(Global.attack1t, 20, 30):
			wave.set_pos(player.position + Vector2((Global.player_dir * 7 * Global.attack1t) - (Global.player_dir * 95), -75))

		if Global.attack1t == 30:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

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
	class_anim.speed_scale = 2
	
	if Global.attack2t >= 1:
		player.set_speed_penalty(0.1)
		
		Global.attack2t += 1
		
		# spawns wave
		if between(Global.attack2t, 30, 34) and Global.attack2t % 2 == 0:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			wave.set_damage(15)
			wave.set_knockback(5)
			wave.set_pos(Vector2(player.position.x, player.position.y + randi_range(-150, -20)))
			wave.set_speed(40 + randi_range(-10,20), 0)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if Global.attack2t == 40:
			player.set_animation_visibility(true)
			class_anim.visible = false
			player.set_attacking(false)

		if Global.attack2t >= attack2_max_t:
			Global.attack2t = 0

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

func _physics_process(_delta: float) -> void:
	update_global_cds()
	attack_1()
	attack_2()
