extends Node2D

var offset = Vector2(100, 0)

func set_size(value):
	self.scale = Vector2(value, value)

func set_offset(value):
	offset = value

func fix_pos(direction):
	position = Vector2(direction * offset[0], offset[1])

func set_text(txt):
	$RichTextLabel.text = txt
