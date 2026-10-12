extends Node2D

@onready var menu = $pause_menu

func pause():
	menu.visible = true
	get_tree().paused = true

func unpause():
	menu.visible = false
	get_tree().paused = false

func _on_pause_button_main_button_up() -> void:
	if menu.visible == true:
		unpause()
	else:
		pause()
