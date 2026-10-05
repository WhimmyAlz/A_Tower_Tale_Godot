extends Node2D

var life_time = 30

func _physics_process(_delta: float) -> void:
	if life_time > 0:
		life_time -= 1
		
	if life_time == 0:
		queue_free()
	
	if life_time > 10 and position.y < -100:
		position.y += 200
