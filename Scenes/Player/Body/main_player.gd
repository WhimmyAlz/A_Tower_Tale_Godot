extends Node2D

var screenshake_time = -1
var shop_opened = false

func get_body():
	return($PlayerBody)

func get_status_effect():
	return($"Non Attached UI Elements/Status_effects")

func set_screenshake(time):
	screenshake_time = time

func _physics_process(_delta: float) -> void:
	if screenshake_time >= 0:
		screenshake_time -= 1
		
		if screenshake_time > 0:
			$Camera2D.position = Vector2(randi_range(-10,10),randi_range(-20,0))
		
		if screenshake_time == 0:
			$Camera2D.position = Vector2(0,-10)

func change_class(cls):
	var current_health_percentage = Global.health/Global.max_health

	Global.attack1t = 0
	Global.attack2t = 0
	Global.attack3t = 0
	Global.attack4t = 0
	Global.attack5t = 0
	Global.ultimatet = 0
	Global.player_class = cls

	Global.check_class()
	Global.health = Global.max_health * current_health_percentage
	$PlayerBody/Class_Actions.set_class_items()

func set_shop_opened(val = true):
	shop_opened = val
	$"Non Attached UI Elements/MoveList".ignore_filter(val)
