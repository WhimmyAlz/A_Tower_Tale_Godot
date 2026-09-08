extends Node2D

var screenshake_time = -1

func get_body():
	return($PlayerBody)

func set_screenshake(time):
	screenshake_time = time

func _physics_process(_delta: float) -> void:
	if screenshake_time >= 0:
		screenshake_time -= 1
		
		if screenshake_time > 0:
			$Camera2D.position = Vector2(randi_range(-10,10),randi_range(-20,0))
		
		if screenshake_time == 0:
			$Camera2D.position = Vector2(0,-10)
