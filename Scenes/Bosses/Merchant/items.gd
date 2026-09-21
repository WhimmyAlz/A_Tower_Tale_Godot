extends Node2D

@export var Item = ""

static var class_ball_sprites = [preload("res://Scenes/Bosses/Merchant/sprites/shop/class_ball/class_ball_1.png"), preload("res://Scenes/Bosses/Merchant/sprites/shop/class_ball/class_ball_2.png")]
static var medkit_sprites = [preload("res://Scenes/Bosses/Merchant/sprites/shop/medkit/medkit_1.png"), preload("res://Scenes/Bosses/Merchant/sprites/shop/medkit/medkit_2.png")]

var description = ""

func set_button_properties():
	if Item == "CLASS_BALL":
		$TextureButton.texture_normal = class_ball_sprites[0]
		$TextureButton.texture_hover = class_ball_sprites[1]
		$TextureButton.texture_pressed = class_ball_sprites[0]
		description = "Changes your class"
	if Item == "MEDKIT":
		$TextureButton.texture_normal = medkit_sprites[0]
		$TextureButton.texture_hover = medkit_sprites[1]
		$TextureButton.texture_pressed = medkit_sprites[0]
		description = "Heals yourself"

func _ready() -> void:
	set_button_properties()
