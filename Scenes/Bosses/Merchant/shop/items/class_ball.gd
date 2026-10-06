extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

static var class_list = ["brawler", "needle", "reaper", "paladin"]
static var freebie = 1

var Item = "CLASS_BALL"

func set_button_descriptions():
	if Global.player_class == class_list[value]:
		raw_description = "Your class is already %s." % class_list[value]
	elif player.get_attacking():
		raw_description = "I'm gonna need you to wait a few seconds when you're not attacking so you don't break the delicate code."
	elif price == 0:
		raw_description = "Change class to %s for free?" % [class_list[value]]
	elif check_price("You need at least %d xp to buy the %s class brokie." % [price, class_list[value]]):
		raw_description = "Change class to %s for %d xp?" % [class_list[value], price]
	description = "[b]%s[/b]" % raw_description
	$RichTextLabel.text = class_list[value][0].capitalize()
	
func set_item_values():
	price = 25
	if freebie == 1 and price == 25:
		price = 0

func _ready() -> void:
	value = 0
	value_range = [0, len(class_list)-1]
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
	if mouse_over:
		if Global.player_XP >= price and Global.player_class != class_list[value] and not player.get_attacking():
			player.get_parent().change_class(class_list[value])
			if price == 0:
				freebie -= 1
			else:
				Global.player_XP -= price

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
