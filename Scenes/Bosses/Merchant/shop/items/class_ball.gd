extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

static var class_list = ["brawler", "needle", "reaper", "paladin", "shadow"]
static var freebie = 1

var required_items := {}

var Item = "CLASS_BALL"

func set_button_descriptions():
	if Global.player_class == class_list[value]:
		raw_description = "Your class is already %s." % class_list[value]
	elif player.get_attacking():
		raw_description = "I'm gonna need you to wait a few seconds when you're not attacking so you don't break the delicate code."
	elif check_items():
		if price == 0:
			if len(get_required_items()) == 0:
				raw_description = "Change class to %s for free?" % [class_list[value]]
			else:
				raw_description = "Change class to %s for %s?" % [class_list[value], get_required_items()]
		elif check_price("You need at least %d xp to buy the %s class brokie." % [price, class_list[value]]):
			
			if len(get_required_items()) == 0:
				raw_description = "Change class to %s for %d xp?" % [class_list[value], price]
			else:
				raw_description = "Change class to %s for %sand %d xp?" % [class_list[value], get_required_items(), price]
	description = "[b]%s[/b]" % raw_description
	$RichTextLabel.text = class_list[value][0].capitalize()

func get_required_items():
	var required_items_str = ""
	if len(required_items.keys()) == 1:
		required_items_str += "%s %s" % [required_items[required_items.keys()[0]], required_items.keys()[0]]
	else:
		for i in range(len(required_items.keys())):
			required_items_str += "%s %s, " % [required_items[required_items.keys()[i]], required_items.keys()[i]]
	return(required_items_str)

func check_items():
	var items_check = true
	for i in range(len(required_items.keys())):
		if not player.check_item(required_items.keys()[i], required_items[required_items.keys()[i]]):
			items_check = false

	if not items_check:
		raw_description = "You need %sand %d xp to get the %s class broski." % [get_required_items(), price, class_list[value]]
		description = "[b]%s[/b]" % raw_description
		return(false)
	return(true)

func set_item_values():
	required_items = {}
	if value >= 0 and value <= 3:
		price = 25
	if value == 4:
		price = 99
		required_items = {"Shadow Essence": 12, "Bone Fragment": 30}
	if freebie == 1 and value >= 0 and value <= 3:
		price = 0

func _ready() -> void:
	value = 0
	value_range = [0, len(class_list)-1]
	set_button_descriptions()
	set_button_textures()

func increment(val):
	if val < 0:
		value = maxi(value + val, value_range[0])
	elif val > 0:
		value = mini(value + val, value_range[1])
	
	set_item_values()
	set_button_descriptions()

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
	var items_check = true
	for i in range(len(required_items.keys())):
		if not player.check_item(required_items.keys()[i], required_items[required_items.keys()[i]]):
			items_check = false

	if mouse_over:
		if Global.player_XP >= price and Global.player_class != class_list[value] and not player.get_attacking() and items_check:
			player.get_parent().change_class(class_list[value])
			if price == 0:
				freebie -= 1
			else:
				Global.player_XP -= price
				for i in range(len(required_items.keys())):
					player.remove_item(required_items.keys()[i], required_items[required_items.keys()[i]])

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
