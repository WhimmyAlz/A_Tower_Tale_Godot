extends Node2D

var random_dir = [-1, 1].pick_random()
var random_value_x = randf_range(0.1, 2)
var random_value_y = randf_range(-2.5, -0.5)

var life_time = 30

func set_pos(pos):
	self.position = pos

func set_text(txt):
	$text.text = str(txt)

func set_size(value):
	$text.add_theme_font_size_override("normal_font_size", value * 64)

func set_color(col):
	$text.set("theme_override_colors/default_color", col)

func _physics_process(_delta: float) -> void:
	set_pos(self.position + Vector2(random_dir * random_value_x, random_value_y))
	life_time -= 1
	if life_time == 0:
		queue_free()
