extends Node2D


func _ready() -> void:
	$TextureProgressBar.max_value = get_parent().get_max_health()

func update_value(hp):
	$TextureProgressBar.value = hp
	$RichTextLabel.text = str(snappedf(hp, 0.1))

func update_max_value(hp):
	$TextureProgressBar.max_value = hp

func update_name(txt):
	$name.text = txt

func set_name_size(val):
	$name.set("theme_override_font_sizes/bold_font_size", val)
