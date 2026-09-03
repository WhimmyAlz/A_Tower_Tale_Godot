extends Area2D

var entered = false
@onready var base_floor = get_parent().get_parent()

var preload_skelebone = preload("res://Scenes/Mobs/Skelebone/skelebone.tscn")

func set_pos(vector2):
	position = vector2

func progress_floor():
	Global.floors += 1
	base_floor.bg_add_y_pos()
	init_floor_mobs(Global.floors)

func spawn_skeleton(pos, level):
	var skelebone = preload_skelebone.instantiate()
	skelebone.set_pos(pos)
	skelebone.Level = level
	base_floor.add_enemy(skelebone)

func init_floor_mobs(floor_num):
	if floor_num == 1:
		spawn_skeleton(Vector2(0, 0), 10)
	elif floor_num == 2:
		spawn_skeleton(Vector2(600, 0), 30)
		spawn_skeleton(Vector2(700, 0), 30)
	elif floor_num == 3:
		spawn_skeleton(Vector2(0, 0), 100)

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
