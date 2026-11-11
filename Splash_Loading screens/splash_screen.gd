extends Node2D

func _on_start_button_pressed() -> void:
	Global.reset_stats()
	Global._ready()
	get_tree().change_scene_to_file("res://Scenes/Settings/Floor/Base_floor.tscn")
