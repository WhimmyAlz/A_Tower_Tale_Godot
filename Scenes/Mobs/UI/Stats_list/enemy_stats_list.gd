extends Node2D

var offset = Vector2(100, 0)

@onready var parent = get_parent()

func set_size(value):
	self.scale = Vector2(value, value)

func set_offset(value):
	offset = value

func fix_pos():
	if get_global_mouse_position()[0] > parent.position.x:
		position = Vector2(1 * offset[0], offset[1])
	else:
		position = Vector2(-1 * offset[0], offset[1])

func set_text(txt):
	$RichTextLabel.text = txt
