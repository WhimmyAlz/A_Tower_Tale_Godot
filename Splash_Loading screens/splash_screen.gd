extends Node2D

func _on_start_button_pressed() -> void:
	Global.reset_stats()
	Global._ready()
	get_tree().change_scene_to_file("res://Scenes/Settings/Floor/Base_floor.tscn")


func _on_texture_button_pressed() -> void:
	$gore_warning.visible = false
	Global.gore = true

func _on_texture_button_2_pressed() -> void:
	$gore_warning.visible = false
	Global.gore = false
