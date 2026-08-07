extends Node2D

var attack1_max_t = 30
var attack2_max_t
var attack3_max_t
var attack4_max_t
var attack5_max_t
var ultimate_max_t

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
	set_dir()
	
	player.set_animation_visibility(false)
	class_anim.visible = true
	class_anim.frame = 0
	class_anim.play("punch")
	Global.attack1t = 1
	player.set_attacking(true)

func between(variable, time1, time2):
	if variable >= time1 and variable <= time2:
		return(true)
	else:
		return(false)

func attack_1():
	class_anim.speed_scale = attack1_max_t * 0.1
	
	if Global.attack1t >= 1:
		Global.attack1t += 1
		
		# spawns wave
		if Global.attack1t == 20:
			wave = fist_wave.instantiate()
			wave.set_player(player)
			wave.set_pos(player.position)
			wave.set_speed(0, 0)
			get_tree().current_scene.get_node("Projectiles").add_child(wave)

		if between(Global.attack1t, 20, 30):
			wave.set_pos(player.position + Vector2(Global.player_dir * 5 * Global.attack1t, -85))
		
		if Global.attack1t >= attack1_max_t:
			player.set_animation_visibility(true)
			class_anim.visible = false
			Global.attack1t = 0
			player.set_attacking(false)

func _physics_process(_delta: float) -> void:
	attack_1()
