extends Node2D

var lifetime = 180
var player

func set_player_pos(val):
	player = val

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime < 30:
		position.y += 100
	else:
		position = player.position
	
	if lifetime == 0:
		queue_free()
