extends Node2D

var arrow = "left" 

func set_arrow(val):
	arrow = val

func _ready() -> void:
	if arrow == "left":
		position.x = -245
		$TextureButton.flip_h = true
	if arrow == "right":
		position.x = 155

func _on_texture_button_button_up() -> void:
	if arrow == "left":
		get_parent().increment(-1)
	if arrow == "right":
		get_parent().increment(1)
	
	get_parent().reset_chat()
