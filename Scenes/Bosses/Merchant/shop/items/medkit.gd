extends "res://Scenes/Bosses/Merchant/shop/items/items_base.gd"

var Item = "MEDKIT"

func set_button_descriptions():
	if Global.health >= Global.max_health:
		raw_description = "You got more than enough health. Probably."
	elif check_price():
		raw_description = "Heals yourself for %0.1f Health for %d xp. (1%% of max health per xp spent)" % [value * 0.01 * Global.max_health, int(value)]
	description = "[b]%s[/b]" % raw_description

func set_item_values():
	if Global.health < Global.max_health:
		start_pause = 0
		value = minf(((1 - (Global.health/Global.max_health)) * 100), Global.player_XP)
		if is_zero_approx(value - int(value)):
			value = int(value)
		else: 
			value = snapped(value, 0.1)
	else:
		value = 0
		start_pause = 30

func _ready() -> void:
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
		Global.health += value * 0.01 * Global.max_health
		Global.player_XP -= int(value)

		set_item_values()
		set_button_descriptions()
		player.update_hp_bar()
		if consumable:
			shop.set_chat("[b]Thank you for buying, please come again.[/b]", "Thank you for buying, please come again.")
		else:
			reset_chat()

		if consumable:
			queue_free()


func _on_texture_button_mouse_exited() -> void:
	mouse_over = false
