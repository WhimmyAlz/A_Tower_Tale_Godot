extends AnimatedSprite2D

var close = false

func end():
	play("end")

func _on_animation_finished() -> void:
	if animation == "start":
		play("loop")
	elif animation == "end":
		queue_free()
