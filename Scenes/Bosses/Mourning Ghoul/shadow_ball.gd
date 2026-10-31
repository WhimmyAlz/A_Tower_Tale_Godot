extends Node2D

var level 
var lifetime := randi_range(130, 170)

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

func spawn_shadow_hand():
	var shadow_hand = preload("res://Scenes/Mobs/shadow_hand/Shadow_hand.tscn").instantiate()
	shadow_hand.set_pos(position)
	shadow_hand.Level = level
	shadow_hand.death_rewards = 0
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
		if randi_range(0, 1) == 1:
			spawn_chomper()
		else:
			spawn_shadow_hand()
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		lifetime = 1
