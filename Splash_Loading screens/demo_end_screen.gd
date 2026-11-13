extends Node2D

func _physics_process(_delta: float) -> void:
	if $Panel2.modulate.a > 0:
		$Panel2.modulate.a -= 0.01

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Splash_Loading screens/Splash_screen.tscn")
