extends Control

var lifetime = 240

# Rarity: common-white, uncommon-coral, rare-lawn_green, super_rare-red, epic-aqua, Mythic-purple, Legendary-Black

func set_text(text, color=Color.WHITE):
	$RichTextLabel.set("theme_override_colors/default_color", color)
	$RichTextLabel.text = "+ %s" % text
	$".".custom_minimum_size.y = $RichTextLabel.size.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if lifetime > 0:
		lifetime -= 1

		if lifetime < 60:
			modulate.a -= 0.016

	if lifetime == 0:
		queue_free()
	
