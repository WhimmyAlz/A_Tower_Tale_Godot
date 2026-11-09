extends Node2D

var angle = null

func set_size(val):
	scale = Vector2(val, val)

func set_angle(val):
	rotation = val

func set_dir(val):
	if val == -1:
		$AnimatedSprite2D.flip_h = true

func set_rotate(val):
	rotation_degrees = val

func set_pos(val1, val2):
	position = Vector2(val1, val2)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
