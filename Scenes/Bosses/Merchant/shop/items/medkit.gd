extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

var Item = "MEDKIT"

func set_button_descriptions():
	if Global.health == Global.max_health:
		raw_description = "Your health is full."
	elif check_price():
		raw_description = "Heals yourself for %0.1f Health for %d xp. (1 health per xp spent)" % [value, int(value)]
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	value = minf(Global.max_health - Global.health, Global.player_XP)

func _ready() -> void:
	set_button_descriptions()
	set_button_textures()

## item hover
func _on_texture_button_mouse_entered() -> void:
	set_item_values()
	set_button_descriptions()
	create_arrows()
	hide_buttons()
	show_arrows(true)

	reset_chat()

## item used
func _on_texture_button_button_up() -> void:
	Global.health += value
	Global.player_XP -= int(value)

	set_item_values()
	set_button_descriptions()
	
	if consumable:
		shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
	else:
		reset_chat()

	if consumable:
		queue_free()
