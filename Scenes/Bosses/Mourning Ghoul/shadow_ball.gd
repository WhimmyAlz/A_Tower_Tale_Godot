extends Node2D

var level 
var lifetime := randi_range(130, 170)
var enemy = null

func set_enemy(val):
	enemy = val

func set_pos(val):
	position = val

func set_level(val):
	level = val

func set_scales(val):
	scale = Vector2(val, val)

func spawn_chomper():
	var chomper = preload("res://Scenes/Mobs/chomper/chomper.tscn").instantiate()
	chomper.set_pos(position)
	chomper.Level = level
	chomper.death_rewards = 0
	get_tree().current_scene.get_node("Enemies").add_child(chomper)

func spawn_skelebone():
	var skelebone = preload("res://Scenes/Mobs/Skelebone/skelebone.tscn").instantiate()
	skelebone.set_pos(position)
	skelebone.Level = level+6
	skelebone.death_rewards = 0
	get_tree().current_scene.get_node("Enemies").add_child(skelebone)


func spawn_shadow_hand():
	var shadow_hand = preload("res://Scenes/Mobs/shadow_hand/Shadow_hand.tscn").instantiate()
	shadow_hand.set_pos(position)
	shadow_hand.Level = level
	shadow_hand.death_rewards = 0
	shadow_hand.set_kamakazie(true)
	get_tree().current_scene.get_node("Enemies").add_child(shadow_hand)


func _ready() -> void:
	if randi_range(0, 1) == 1:
		$AnimatedSprite2D.flip_h = true

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	position.y += (0.02 * (970 - position.y))
	rotate(0.1)
	
	if lifetime < 60:
		scale *= Vector2(0.97, 0.97)
	
	if lifetime == 0:
		if enemy == null:
			var rand = randi_range(0, 1)
			if rand == 0:
				spawn_chomper()
			elif rand == 1:
				spawn_shadow_hand()

		elif enemy == "hand":
			spawn_shadow_hand()
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		lifetime = 1
