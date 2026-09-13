extends Control

var status = ""
var status_level = 0
var lifetime := 0
var color = Color.WHITE
var description = ""

func set_description():
	if status == "Berserk":
		description = "+10 Strength\n+15 Agility\n+100% Stamina regen\n\nSecond and fourth attacks of the brawler class inflicts fire."
	
	$description/RichTextLabel.text = description

func set_status(txt):
	status = txt

func set_status_level(value):
	status_level = value

func get_status():
	return(status)

func set_time(value):
	lifetime = value

func update_desc():
	if status_level == 1:
		$RichTextLabel.text = "[b]%s[/b]\n[color=white]%.2fs[/color]" % [status, float(lifetime)/60]
	else:
		$RichTextLabel.text = "[b]%s %f[/b]\n[color=white]%.2fs[/color]" % [status, status_level, float(lifetime)/60]

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
