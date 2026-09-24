extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

static var consumable_list = ["syringe", "unknown"]
static var buff_values = ["+2 STR"]

static var syringe_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/syringe/syringe_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/syringe/syringe_2.png")]

var Item = "CONSUMABLE"

func set_textures():
	$TextureButton.texture_normal = syringe_sprites[0]
	$TextureButton.texture_pressed = syringe_sprites[0]
	$TextureButton.texture_hover = syringe_sprites[1]

func set_button_descriptions():
	if check_price("%s\n\nYou need at least %d xp to buy the %s brokie." % [buff_values[value], price, consumable_list[value]]):
		raw_description = "%s\n\nBuy the %s for %d xp?" % [buff_values[value], consumable_list[value], price]
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	if value == 0:
		price = randi_range(10,20)
	if value == 1:
		price = 20

func _ready() -> void:
	value = randi_range(0,0)
	
	if value == 0:
		Item = "SYRINGE"
	
	consumable = true
	set_textures()
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

	if Global.player_XP >= price:
		if Item == "SYRINGE":
			Global.bonus_strength += 2

		set_item_values()
		set_button_descriptions()
		
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()
