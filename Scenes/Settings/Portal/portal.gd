extends Area2D

var entered = false
@onready var base_floor = get_parent().get_parent()

var preload_skelebone = preload("res://Scenes/Mobs/Skelebone/skelebone.tscn")
var preload_nerd = preload("res://Scenes/Mobs/Nerd/nerd.tscn")
var preload_sir_blob = preload("res://Scenes/Bosses/Sir Blob/sir_blob.tscn")
var preload_undead_ranger = preload("res://Scenes/Mobs/Undead_ranger/Undead_ranger.tscn")
var preload_undead_warrior = preload("res://Scenes/Mobs/undead_warrior/undead_warrior.tscn")
var preload_chomper = preload("res://Scenes/Mobs/chomper/chomper.tscn")
var preload_odon = preload("res://Scenes/Bosses/Odon/odon.tscn")
var preload_nell = preload("res://Scenes/Bosses/Nell/Nell.tscn")

func set_pos(vector2):
	position = vector2

func progress_floor():
	Global.floors += 1
	
	var enemy_list = get_tree().current_scene.get_node("Enemies")
	
	for i in range(enemy_list.get_child_count()):
		if enemy_list.get_child(i).is_in_group("merchant"):
			enemy_list.get_child(i).delete()
	
	var player = get_tree().current_scene.get_node("Player").get_child(0)
	player.reset_regen_amount()
	
	base_floor.bg_add_y_pos()
	init_floor_mobs(Global.floors)

func spawn_skeleton(pos, level):
	var skelebone = preload_skelebone.instantiate()
	skelebone.set_pos(pos)
	skelebone.Level = level
	base_floor.add_enemy(skelebone)

func spawn_nerd(pos, level):
	var nerd = preload_nerd.instantiate()
	nerd.set_pos(pos)
	nerd.Level = level
	base_floor.add_enemy(nerd)

func spawn_sir_blob(pos, level):
	var sir_blob = preload_sir_blob.instantiate()
	sir_blob.set_pos(pos)
	sir_blob.Level = level
	base_floor.add_enemy(sir_blob)

func spawn_undead_ranger(pos, level):
	var undead_ranger = preload_undead_ranger.instantiate()
	undead_ranger.set_pos(pos)
	undead_ranger.Level = level
	base_floor.add_enemy(undead_ranger)

func spawn_undead_warrior(pos, level):
	var undead_warrior = preload_undead_warrior.instantiate()
	undead_warrior.set_pos(pos)
	undead_warrior.Level = level
	base_floor.add_enemy(undead_warrior)

func spawn_chomper(pos, level):
	var chomper = preload_chomper.instantiate()
	chomper.set_pos(pos)
	chomper.Level = level
	base_floor.add_enemy(chomper)

func spawn_odon(pos, level):
	var odon = preload_odon.instantiate()
	odon.set_pos(pos)
	odon.Level = level
	base_floor.add_enemy(odon)

func spawn_nell(pos, level):
	var nell = preload_nell.instantiate()
	nell.set_pos(pos)
	nell.Level = level
	base_floor.add_enemy(nell)

func init_floor_mobs(floor_num):
	if floor_num == 1:
		spawn_nerd(Vector2(800, 0), 2)
		spawn_skeleton(Vector2(0, 0), 3)
	elif floor_num == 2:
		spawn_skeleton(Vector2(-700, 0), 5)
		spawn_skeleton(Vector2(700, 0), 5)
	elif floor_num == 3:
		spawn_nerd(Vector2(500, 0), 2)
		spawn_skeleton(Vector2(0, 0), 8)
	elif floor_num == 4:
		spawn_nerd(Vector2(500, 0), 3)
		spawn_skeleton(Vector2(0, 0), 10)
	elif floor_num == 5:
		spawn_sir_blob(Vector2(700, 0), 1)
	elif floor_num == 6:
		spawn_undead_ranger(Vector2(700, 0), 5)
		spawn_undead_ranger(Vector2(-700, 0), 5)
	elif floor_num == 7:
		spawn_skeleton(Vector2(700, 0), 10)
		spawn_undead_ranger(Vector2(-700, 0), 7)
	elif floor_num == 8:
		spawn_nerd(Vector2(800, 0), 6)
		spawn_undead_warrior(Vector2(600, 0), 8)
		spawn_undead_ranger(Vector2(-700, 0), 8)
	elif floor_num == 9:
		spawn_chomper(Vector2(700, 0), 7)
		spawn_undead_ranger(Vector2(-700, 0), 8)
		spawn_skeleton(Vector2(700, 0), 10)
	elif floor_num == 10:
		spawn_odon(Vector2(-700, 0), 1)
		spawn_nell(Vector2(700, 0), 1)

func _physics_process(_delta: float) -> void:
	if entered and Input.is_action_just_released("interact"):
		progress_floor()
		base_floor.reset_portal_limiter()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player"):
		entered = true

func _on_body_exited(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player"):
		entered = false
