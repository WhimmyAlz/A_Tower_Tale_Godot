extends "res://Global/pause_menu/movable.gd"

var level = 1
var increment = 0
var enemies_list = ["nerd", "merchant", "skelebone", "sir blob", "undead ranger", "undead warrior", "chomper", "nell", "odon", "gray bird"]
#							   health  damage  def  dpen  speed  extra / quotes / desc / drops
var enemies_stats = {"nerd" : ["80 40", "25 2", "0", "0", "10", "Nothing special.", "Erm Ackually", "A typical Nerd. Hopefully he doesn't try to talk to me.\n\n\nAttacks[left]\nPunch: Simple punch, deals 100% damage[/left]", "Drops:\n10% Ultimate Attack\n\nMutually Exclusive Drops:\nNew Attack\n36-48xp"],
#			    health    dmg  def  dpen  spd  extra / quote / desc / drops
"merchant" : ["1000 10", "10 0.5", "20 0.5", "10", "3", "Attacks after reaching half health.\nIgnores Knockback.\nHeals 50% of max health when health intially reaches 0.\n50% less damage from bleed and deathmark", "Don't think I can't defend my merchandise.", "A strange voice is coming from within.\n\n\n\nAttacks[left]\nShock Orb: Fires up shock orbs that deal 10% Damage and 1.5s stun and then turns into a thorn. Inflicts [color=yellow]shock 15[/color]. \n\nShock Thorn: A sharp thorn that fires towards you dealing 100% damage and inflicts [color=yellow]shock 15[/color], [color=red]bleed 2[/color], [color=purple]venom 2[/color].[/left]", "Drops:\n100% 50-100xp"],
"skelebone" : ["50 25", "20 1", "7", "0", "2", "Immune to bleed.", "Clank Clank.", "A living skeleton. He needs some milk.\n\n\n\nAttacks[left]\nBone toss: An aimed arm bone that is thrown towards you. Deals 100% damage.[/left]", "Drops:\n100% 6-12xp"],
"sir blob" : ["1000 150", "60 5", "0", "0", "3", "25% less stun taken.", "...", "Some say this is what happens when you leave an orange behind a fridge for too long.\n\n\nAttacks[left]\nSlam: Big fall, big damage, big knockback. Big business. Deals 100% damage.[/left]", "Drops:\n100% 64-84xp"],
"undead ranger" : ["120 35", "15 1", "0", "5", "0", "Full map range.\nAttacks 3x in a row unless interrupted.", "I was once an adventurer like you...", "A long dead adventurer.. Incredibly weak to stuns.\n\n\nAttacks[left]\nLong shot: Shoots an arrow that flies straight across the map dealing 100% damage. Can be interrupted[/left]", "Drops:\n100% 10-16xp"],
"undead warrior" : ["220 45", "22 1.5", "2", "0", "10", "Gets 20% larger, 25% more damage, 30% more speed, and loses 1s of time between attacks at half hp", "Let me axe you a question...", "Another long dead adventurer. Enrages after reaching half health.\n\n\nAttacks[left]\nHere's Johnny!: Big axe chops dealing 100% damage and big knockback.[/left]", "Drops:\n100% 12-18xp"],
"chomper" : ["350 50", "30 3", "1", "0", "7", "Disappears after attacking, teleports before attacking.", "\"Nom Nom Nom\"", "That friend that asks for a bite.\n\n\n\nAttacks[left]\nChomp: Bites down and deals 100% damage. Can be interrupted[/left]", "Drops:\n100% 12-18xp"],
"nell" : ["900 90", "10 1", "2", "10", "4", "Dodges and sends someone towards you. Dodges also readies her arrows.\nShoots 3x in a row unless interrupted.\nIf interrupted before 3rd shot then dodge.", "\"My arrows will pierce your heart!\"", "A member of a hero party lost in the past. The ranger of the twins.\n\n\n\nAttacks[left]\nFire shot: Shoots a fire arrow that flies straight across the map dealing 100% damage. Inflicts [color=orange]fire 5[/color].[/left]", "Drops:\n100% 60-72xp"],
"odon" : ["1400 120", "30 5", "4", "0", "4", "Takes 70% reduced stun time.", "\"Baby spin me round...\"", "A member of a hero party lost in the past. The juggernaut of the twins.\n\n\n\nAttacks[left]\nSpear Thrust: Stabs with spear, deals 100% damage.\n\nWhirl Spin: Performs a small lunge before spinning spear dealing 5% damage 9 times followed by 75% damage once.[/left]", "Drops:\n100% 60-72xp"],
"gray bird" : ["180 40", "30 1.5", "8", "0", "8", "Accelerates when moving.\nWon't attack until nearby.", "\"Why are my legs so messed up?\"", "\"Sorry i'm bad at drawing legs\" -Developer\n\n\n\nAttacks[left]\nPeck: A swift peck that deals 100% damage.\n\nTriple Peck: 3 swift pecks that deals 50% damage each.[/left]", "Drops:\n100% 14-22xp"],
}

func set_name_text(em_name):
	$VBoxContainer/enemy_name.text = "[b]%s[/b]" % [em_name]

func _ready() -> void:
	$Stats_bg/description.get_v_scroll_bar().modulate.a = 0

func _on_line_edit_text_changed(_new_text: String) -> void:
	var text = $VBoxContainer/level/LineEdit.text
	if text.is_valid_int() or text == "":
		if text == "":
			level = 1
		else:
			level = int(text)
		set_all()
		$VBoxContainer/level/RichTextLabel.text = ""
	else:
		$VBoxContainer/level/RichTextLabel.text = "[b][font_size=36]Error: Not a valid interger[/font_size][/b]\n "

func calc_stats(stat):
	var split_stats = stat.split(" ")
	
	if len(split_stats) == 1:
		return(int(split_stats[0]))
	else:
		return(int(split_stats[0]) + ((level-1) * float(split_stats[1])))

func set_all():
	$Stats_bg/Stats1/health.text = "[b]Health: %d" % calc_stats(enemies_stats[enemies_list[increment]][0])
	$Stats_bg/Stats1/damage.text = "[b]Damage: %d" % calc_stats(enemies_stats[enemies_list[increment]][1])
	$Stats_bg/Stats1/defense.text = "[b]Defense: %d" % calc_stats(enemies_stats[enemies_list[increment]][2])
	$Stats_bg/Stats1/defensepen.text = "[b]Defense Pen: %d" % calc_stats(enemies_stats[enemies_list[increment]][3])
	$Stats_bg/Stats2/speed.text = "[b]Speed: %d" % calc_stats(enemies_stats[enemies_list[increment]][4])
	$Stats_bg/Stats2/extra.text = "[b]Extra Stuff: %s" % enemies_stats[enemies_list[increment]][5]
	
	$Stats_bg/quote.text = "[i]\"%s\"[/i]" % enemies_stats[enemies_list[increment]][6]
	$Stats_bg/description.text = "[b]%s[/b]" % enemies_stats[enemies_list[increment]][7]
	$TileMapLayer2/drops.text = "%s" % enemies_stats[enemies_list[increment]][8]
	
	set_name_text(enemies_list[increment].capitalize())
	if len(enemies_list[increment]) > 10:
		$VBoxContainer/enemy_name.add_theme_font_size_override("bold_font_size", 100 - (4 * (len(enemies_list[increment])-10)))
	else:
		$VBoxContainer/enemy_name.add_theme_font_size_override("bold_font_size", 120)
	$VBoxContainer/sprite.play(enemies_list[increment])

func _on_button_right_pressed() -> void:
	$Stats_bg/description.scroll_to_line(0)
	if increment < len(enemies_list)-1:
		if increment == 0:
			$button_left.visible = true
		increment += 1
		set_all()
		var size = $VBoxContainer/sprite.sprite_frames.get_frame_texture($VBoxContainer/sprite.animation, 0).get_size()
		var scale_factor = min(320/size[0], 320/size[1])
		$VBoxContainer/sprite.scale = Vector2(scale_factor, scale_factor)
	if increment == len(enemies_list)-1:
		$button_right.visible = false

func _on_button_left_pressed() -> void:
	$Stats_bg/description.scroll_to_line(0)
	if increment > 0:
		if increment == len(enemies_list)-1:
			$button_right.visible = true
		increment -= 1
		set_all()
		var size = $VBoxContainer/sprite.sprite_frames.get_frame_texture($VBoxContainer/sprite.animation, 0).get_size()
		var scale_factor = min(320/size[0], 320/size[1])
		$VBoxContainer/sprite.scale = Vector2(scale_factor, scale_factor)
	if increment == 0:
		$button_left.visible = false
