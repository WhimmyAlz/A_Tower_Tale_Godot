extends Node2D


func _ready() -> void:
	$TextureProgressBar.max_value = get_parent().get_max_health()

func update_value(hp):
	$TextureProgressBar.value = hp
	$RichTextLabel.text = str(snappedf(hp, 0.1))

func update_max_value(hp):
	$TextureProgressBar.max_value = hp
