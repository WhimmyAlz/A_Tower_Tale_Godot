extends Node2D



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Settings/Floor/Base_floor.tscn")
