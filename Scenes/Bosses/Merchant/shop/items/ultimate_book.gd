extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

var Item = "ULTIMATE_BOOK"

func set_button_descriptions():
	if Global.ultimate_attack == 1:
		raw_description = "You have already unlocked your ultimate attack."
	elif check_price("You need at least %d xp to buy your ultimate brokie." % price):
		raw_description = "I found this old ass book in the storage room of a cult, it seems to be able to grant a secret power of sorts. Buy your ultimate attack for %d xp?" % price
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	value = 0
	price = 225

func _ready() -> void:
	value = 0
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
	if Global.player_XP >= price and Global.ultimate_attack == 0:
		player.unlock_ultimate()
		Global.player_XP -= price

		set_item_values()
		set_button_descriptions()
		
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()
