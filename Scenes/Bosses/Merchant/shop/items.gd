extends Node2D

@export var Item = ""

static var class_ball_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/class_ball/class_ball_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/class_ball/class_ball_2.png")]
static var medkit_sprites = [preload("res://Scenes/Bosses/Merchant/shop/sprites/medkit/medkit_1.png"), preload("res://Scenes/Bosses/Merchant/shop/sprites/medkit/medkit_2.png")]
static var syringe_sprites = []
static var halo_sprites = []

static var class_list = ["brawler", "needle"]

@onready var shop = $".."

var description = ""
var raw_description = ""
var start_pause = 0

var consumable = false
var value = 0
var price = 1

func set_consumable(val):
	consumable = val

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
		description = "[b]Changes your class to %s[/b]" % class_list[value]
		raw_description = "Changes your class to %s" % class_list[value]

	if Item == "MEDKIT":
		if Global.health == Global.max_health:
			description = "[b]Your health is full[/b]"
			raw_description = "Your health is full"
		else:
			description = "[b]Heals yourself for %0.1f Health for %d xp. (1 health per xp spent)[/b]" % [value, int(value)]
			raw_description = "Heals yourself for %0.1f Health for %d xp. (1 health per xp spent)" % [value, int(value)]
	
	if Global.player_XP <= price:
		description = "[b]You're too broke for this lil bro. It only costs like %d xp.[/b]" % price
		raw_description = "You're too broke for this lil bro. It only costs like %d xp." % price

func set_item_values():
	if Item == "MEDKIT":
		value = minf(Global.max_health - Global.health, Global.player_XP)

func _ready() -> void:
	set_button_descriptions()
	set_button_textures()

## item hover
func _on_texture_button_mouse_entered() -> void:
	set_item_values()
	set_button_descriptions()
	
	if start_pause == 0:
		shop.set_chat(description, raw_description)
	else:
		shop.set_pause_chat(description, raw_description, start_pause)

## item used
func _on_texture_button_button_up() -> void:
	if Item == "MEDKIT":
		Global.health += value
		Global.player_XP -= int(value)

	set_item_values()
	set_button_descriptions()

	if consumable:
		queue_free()
