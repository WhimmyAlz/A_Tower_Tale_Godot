extends Node2D

var preload_portal = preload("res://Scenes/Settings/Portal/Portal.tscn")

var portal_limiter = 1

func reset_portal_limiter():
	portal_limiter = 1

func bg_add_y_pos():
	$Enviroment/Background.position.y = 22 + Global.floors * 1980

func add_enemy(emy):
	$Enemies.add_child(emy)

func spawn_portal():
	var portal = preload_portal.instantiate()
	portal.set_pos(Vector2(-85, 606))
	self.get_node("Enviroment").add_child(portal)

func _physics_process(_delta: float) -> void:
	
	if $Enemies.get_child_count() == 0 and portal_limiter == 1:
		spawn_portal()
		portal_limiter -= 1
