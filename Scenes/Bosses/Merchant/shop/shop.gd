extends Node2D

@onready var player = get_tree().current_scene.get_node("Player").get_body()

var count = 0
var max_count = 0

var count_delay = false
var count_delay_time = 0

var raw_description = ""
var start_pause = 0

func get_player_node():
	return(player)

func set_chat(desc, raw_desc):
	count_delay = false
	count = 0
	max_count = len(raw_desc)
	$text/RichTextLabel.visible_characters = 0
	$text/RichTextLabel.text = desc
	raw_description = raw_desc
	reset_count_delay()

func set_pause_chat(desc, raw_desc, start_pause_count):
	count_delay = true
	count = 0
	max_count = len(raw_desc)
	$text/RichTextLabel.visible_characters = 0
	$text/RichTextLabel.text = desc
	raw_description = raw_desc
	start_pause = start_pause_count

func reset_count_delay():
	count_delay_time = 0

func active():
	player.take_stun(2)
	
	if count_delay:
		if count_delay_time > 0:
			count_delay_time -= 1
			$BG.play("idle")
		if count_delay_time == 0:
			count_text()
			if raw_description[count-1] == " " and count >= start_pause:
				count_delay_time = 60
	else:
		count_text()
		reset_count_delay()

func count_text():
	if count < max_count:
		count += 1
		$text/RichTextLabel.visible_characters = count
		$BG.play("talk")
	else:
		$BG.play("idle")

func _physics_process(_delta: float) -> void:
	if visible == true and Global.stun_time < 2:
		active()

func _on_turtle_collider_mouse_entered() -> void:
	var insult_list = "You have no xp. Bum. Brokie. CS-major. Plebian. Boot-Licker. Vermin. Ungifted. Worthless. Barnicle. Penniless. Basement-Dweller. Chud. Trash-Diver. Spineless. Primate. Potato. Hobo. Shellfish. Impoverished. Underprivileged. "
	if Global.player_XP > 0:
		set_chat("[b]You have %d xp[/b]" % Global.player_XP, "You have %d xp" % Global.player_XP)
	else:
		set_pause_chat("[b]%s[/b]" % insult_list, "%s" % insult_list, 15)
