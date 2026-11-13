extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

var Item = "HALO"

func set_button_descriptions():
	if Global.has_halo:
		raw_description = "You already have a halo?"
	elif check_price("Hey pal, don't think you got enough there, you need %s xp, broke bum." % value):
		raw_description = "Buy a halo for %d?" % [value]
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	value = 300

func _ready() -> void:
	set_button_descriptions()
	set_button_textures()

## item hover
func _on_texture_button_mouse_entered() -> void:
	mouse_over = true
	set_item_values()
	set_button_descriptions()
	create_arrows()
	hide_buttons()
	show_arrows(true)

	reset_chat()

## item used
func _on_texture_button_button_up() -> void:
	if mouse_over and Global.player_XP >= value and not Global.has_halo:
		Global.has_halo = true
		Global.player_XP -= int(value)

		set_item_values()
		set_button_descriptions()
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()


func _on_texture_button_mouse_exited() -> void:
	mouse_over = false
