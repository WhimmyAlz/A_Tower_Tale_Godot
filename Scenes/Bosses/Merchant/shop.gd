extends Node2D

@onready var player = get_tree().current_scene.get_node("Player").get_body()

func _physics_process(_delta: float) -> void:
	if visible == true and Global.stun_time < 2:
		player.take_stun(2)
