extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

static var class_list = ["brawler", "needle"]

var Item = "CLASS_BALL"

func set_button_descriptions():
	if Global.player_class == class_list[value]:
		raw_description = "Your class is already %s." % class_list[value]
	elif player.get_attacking():
		raw_description = "I'm gonna need you to wait a few seconds when you're not attacking so you don't break the delicate code."
	elif check_price("You need at least %d xp to buy the %s class brokie." % [price, class_list[value]]):
		raw_description = "Change class to %s for %d?" % [class_list[value], price]
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	if value == 0:
		price = 50
	if value == 1:
		price = 50

func _ready() -> void:
	value = 0
	value_range = [0, len(class_list)-1]
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
	if Global.player_XP >= price and Global.player_class != class_list[value] and not player.get_attacking():
		player.get_parent().change_class(class_list[value])
		Global.player_XP -= price

		set_item_values()
		set_button_descriptions()
		
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()
