extends Node2D


func _ready() -> void:
	$TextureProgressBar.max_value = get_parent().get_max_health()

func update_value(hp):
	$TextureProgressBar.value = hp

func update_max_value(hp):
	$TextureProgressBar.max_value = hp
