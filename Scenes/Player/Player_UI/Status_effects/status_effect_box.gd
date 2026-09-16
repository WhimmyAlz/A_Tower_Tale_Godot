extends Control

var status = ""
var status_level = 0
var lifetime := 0
var color = Color.WHITE
var description = ""
var text_size = 48

func set_description():
	if status == "Berserk":
		description = "+10 Strength\n+15 Agility\n+100% Stamina regen\n\nSecond and fourth attacks of the brawler class inflicts fire."
	elif status == "Stunned":
		description = "You are currently a vegetable"
	elif status == "Fire":
		description = "Lose 1/2 fire level amount of health every 1/4 second. Ignores 10 defense."
	elif status == "Shock":
		description = "Stun time can now be added instead of overwritten. Take 1% of stun time for each stack of shock you have."
	elif status == "Venom":
		description = "Lose 5 health every 1/6 second. Ignores 25 defense."
	elif status == "Bleeding":
		description = "Lose 1% of max health every 1/2 second. Ignores 1000 defense."
	elif status == "Deathmark":
		description = "Lose 20% of max health if 1000 stacks are reached. Ignores 1000 defense."
	
	$description/RichTextLabel.text = description

func set_status(txt):
	status = txt

func set_status_level(value):
	status_level = value

func get_status():
	return(status)

func set_time(value):
	lifetime = value

func set_text_size(value):
	text_size = value

func update_desc():
	if status_level == 1:
		$RichTextLabel.text = "[b][font_size=%d]%s[/font_size][/b]\n[color=white]%.2fs[/color]" % [text_size, status, float(lifetime)/60]
	elif status_level == int(status_level):
		$RichTextLabel.text = "[b][font_size=%d]%s %.d[/font_size][/b]\n[color=white]%.2fs[/color]" % [text_size, status, int(status_level), float(lifetime)/60]
	else:
		$RichTextLabel.text = "[b][font_size=%d]%s %.1f[/font_size][/b]\n[color=white]%.2fs[/color]" % [text_size, status, status_level, float(lifetime)/60]

func delete():
	queue_free()

func set_color(col):
	color = col
	$RichTextLabel.set("theme_override_colors/default_color", color)

func _process(_delta: float) -> void:
	if lifetime > 0:
		update_desc()
		lifetime -= 1

	if lifetime == 0:
		delete()

func _on_box_area_mouse_entered() -> void:
	set_description()
	$description.visible = true


func _on_box_area_mouse_exited() -> void:
	$description.visible = false
