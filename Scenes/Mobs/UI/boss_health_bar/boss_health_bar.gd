extends Control


func update_value(hp):
	$TextureProgressBar.value = hp

func update_max_value(hp):
	$TextureProgressBar.max_value = hp

func update_name(txt):
	$RichTextLabel.text = txt
