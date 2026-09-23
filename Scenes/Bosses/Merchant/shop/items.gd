extends Node2D

@export var Item = ""

static var class_ball_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/class_ball/class_ball_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/class_ball/class_ball_2.png")]
static var medkit_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/medkit/medkit_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/medkit/medkit_2.png")]
static var syringe_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/syringe/syringe_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/syringe/syringe_2.png")]
static var halo_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/halo/halo_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/halo/halo_2.png")]

static var class_list = ["brawler", "needle"]

@onready var shop = $"../.."

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
	if Item == "CLASS_BALL":
		$TextureButton.texture_normal = class_ball_sprites[0]
		$TextureButton.texture_hover = class_ball_sprites[1]
		$TextureButton.texture_pressed = class_ball_sprites[0]

	if Item == "MEDKIT":
		$TextureButton.texture_normal = medkit_sprites[0]
		$TextureButton.texture_hover = medkit_sprites[1]
		$TextureButton.texture_pressed = medkit_sprites[0]

func set_button_descriptions():
	if Item == "CLASS_BALL":
		if check_price("Changes your class to %s but you're too broke to afford this. This would cost you %d xp." % [class_list[value], price]):
			description = "[b]Changes your class to %s[/b]" % class_list[value]
			raw_description = "Changes your class to %s" % class_list[value]

	if Item == "MEDKIT":
		if Global.health == Global.max_health:
			raw_description = "Your health is full."
		elif check_price():
			raw_description = "Heals yourself for %0.1f Health for %d xp. (1 health per xp spent)" % [value, int(value)]
		description = "[b]%s[/b]" % raw_description

func set_item_values():
	if Item == "CLASS_BALL":
		value_range = [0, len(class_list)-1]
		if value == 0 or value == 1:
			price = 50
	if Item == "MEDKIT":
		value = minf(Global.max_health - Global.health, Global.player_XP)

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
	var player = $"../../..".player

	if Item == "MEDKIT":
		Global.health += value
		Global.player_XP -= int(value)

	if Item == "CLASS_BALL" and Global.player_XP >= price:
		player.get_parent().change_class(class_list[value])

	set_item_values()
	set_button_descriptions()
	
	if consumable:
		shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
	else:
		reset_chat()

	if consumable:
		queue_free()

func _on_texture_button_mouse_exited() -> void:
	pass
