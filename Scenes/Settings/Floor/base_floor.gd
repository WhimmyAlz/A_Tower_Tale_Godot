extends Node2D

var preload_portal = preload("res://Scenes/Settings/Portal/Portal.tscn")
var merchant_preload = preload("res://Scenes/Bosses/Merchant/merchant.tscn")

var portal_limiter = 1

func reset_portal_limiter():
	portal_limiter = 1

func bg_add_y_pos():
	$Enviroment/Background.position.y = Global.floors * 1890

func add_enemy(emy):
	$Enemies.add_child(emy)

func spawn_merchant():
	var merchant = merchant_preload.instantiate()
	merchant.set_pos(Vector2(-700, 670))
	merchant.Level = Global.floors
	add_enemy(merchant)

func spawn_portal():
	var portal = preload_portal.instantiate()
	portal.set_pos(Vector2(-85, 606))
	self.get_node("Enviroment").add_child(portal)

func _physics_process(_delta: float) -> void:
	
	if $Enemies.get_child_count() == 0 and portal_limiter == 1:
		spawn_portal()
		spawn_merchant()

		portal_limiter -= 1
