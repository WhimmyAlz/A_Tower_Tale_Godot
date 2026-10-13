extends Node2D

@onready var menu = $pause_menu
@onready var main_pause_button = $pause_button_main

static var pause_sprites = [preload("res://Global/pause_menu/pause_1.png"), preload("res://Global/pause_menu/pause_2.png")]
static var unpause_sprites = [preload("res://Global/pause_menu/unpause_1.png"), preload("res://Global/pause_menu/unpause_2.png")]

func set_pause_button_sprites(val):
	if val == "pause":
		main_pause_button.texture_normal = pause_sprites[0]
		main_pause_button.texture_pressed = pause_sprites[0]
		main_pause_button.texture_hover = pause_sprites[1]
		main_pause_button.scale = Vector2(2.5, 2.5)
	elif val == "unpause":
		main_pause_button.texture_normal = unpause_sprites[0]
		main_pause_button.texture_pressed = unpause_sprites[0]
		main_pause_button.texture_hover = unpause_sprites[1]
		main_pause_button.scale = Vector2(5, 5)

func pause():
	menu.visible = true
	get_tree().paused = true
	set_pause_button_sprites("unpause")

func unpause():
	menu.visible = false
	get_tree().paused = false
	set_pause_button_sprites("pause")

func _on_pause_button_main_button_up() -> void:
	if menu.visible == true:
		unpause()
	else:
		pause()
