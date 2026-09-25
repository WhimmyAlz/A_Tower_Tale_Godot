extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

var Item = "NERD_BOOK"

func set_button_descriptions():
	if Global.player_attacks == 5:
		raw_description = "You already got all the attacks"
	elif check_price("You need at least %d xp to buy another attack brokie." % price):
		raw_description = "I found this book from some nerd, looks like it teaches new attacks. Buy your next attack for %d xp?" % price
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	value = Global.player_attacks
	price = ((0.5 * value)) * 50

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
	if Global.player_XP >= price and Global.player_attacks < 5:
		player.unlock_attack(1)
		Global.player_XP -= price

		set_item_values()
		set_button_descriptions()
		
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()
