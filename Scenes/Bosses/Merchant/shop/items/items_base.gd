extends Node2D

@onready var shop = $"../.."

@onready var player = get_tree().current_scene.get_node("Player").get_child(0)


var description = ""
var raw_description = ""
var start_pause = 0

var consumable = false
var value = 0
var price = 1

var value_range = [0, 0]
var button_left = null
var button_right = null

func set_consumable(val):
	consumable = val

func show_arrows(val := true):
	if button_left != null:
		button_left.visible = val
		button_right.visible = val

func hide_buttons():
	for i in range($"..".get_child_count()):
		$"..".get_child(i).show_arrows(false)

func increment(val):
	if val < 0:
		value = maxi(value + val, value_range[0])
	elif val > 0:
		value = mini(value + val, value_range[1])
	
	set_button_descriptions()

func create_arrows():
	if value_range != [0, 0] and button_left == null:
		var arrows = preload("res://Scenes/Bosses/Merchant/shop/arrows.tscn")
		
		button_left = arrows.instantiate()
		button_right = arrows.instantiate()
		button_right.set_arrow("right")
		
		self.add_child(button_left)
		self.add_child(button_right)

func set_button_textures():
	pass

func set_button_descriptions():
	pass

func set_item_values():
	pass

func reset_chat():
	if start_pause == 0:
		shop.set_chat(description, raw_description)
	else:
		shop.set_pause_chat(description, raw_description, start_pause)

func check_price(desc = "You're too broke for this lil bro. It only costs like %d xp." % price):
	if Global.player_XP < price:
		raw_description = desc
		description = "[b]%s[/b]" % raw_description
		return(false)
	return(true)
