extends AnimatedSprite2D

var close = false

func end():
	play("end")
	$Lanterns.active = false

func _on_animation_finished() -> void:
	if animation == "start":
		play("loop")
		$Lanterns.active = true
	elif animation == "end":
		queue_free()

func _on_frame_changed() -> void:
	if animation == "start":
		$Lanterns.scale = Vector2($".".frame * 0.02, $".".frame * 0.02)
	elif animation == "end":
		$Lanterns.scale = Vector2(0.16 - $".".frame * 0.03, 0.16 - $".".frame * 0.03)
		if $".".frame > 5:
			$Lanterns.scale = Vector2(0, 0)
