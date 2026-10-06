extends Node2D

var lifetime
var accumlated_damage = 0
var max_healable_health 

@onready var player = get_tree().current_scene.get_node("Player").get_child(0)
@onready var status = player.get_status_effect()

func set_max_healable(val):
	max_healable_health = val

func set_lifetime(val):
	lifetime = val

func active():
	if Global.health < max_healable_health and lifetime % 2 == 0:
		Global.health += 1
		accumlated_damage += 1
		player.update_hp_bar()

func _physics_process(_delta: float) -> void:
	position = player.position + Vector2(0, -50)
	if lifetime >= 10:
		active()
	
	lifetime -= 1
	if lifetime < 10:
		scale *= Vector2(0.92, 0.92)
		if lifetime == 0:
			var negated_damage
			if accumlated_damage >= status.get_retribution():
				negated_damage = status.get_retribution()
			else:
				negated_damage = accumlated_damage
			player.take_damage(accumlated_damage - negated_damage, 10000)
			status.remove_retribution(negated_damage)
			queue_free()
	
