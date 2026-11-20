extends Node2D

@onready var skill_1 = $VBoxContainer/bar_1/bar_1_prog
@onready var skill_2 = $VBoxContainer/bar_2/bar_2_prog
@onready var skill_3 = $VBoxContainer/bar_3/bar_3_prog
@onready var skill_4 = $VBoxContainer/bar_4/bar_4_prog
@onready var skill_5 = $VBoxContainer/bar_5/bar_5_prog
@onready var ultimate = $VBoxContainer/ultimate_bar/ultimate_prog

var ultimate_load = preload("res://Scenes/Player/Player_UI/move_list/ultimate bar sprites/ultimate_charge.png")
var ultimate_complete = preload("res://Scenes/Player/Player_UI/move_list/ultimate bar sprites/ultimate_charge_complete.png")

var mouse_hover_edit = false

func _ready() -> void:
	change_sizes(0)
	$VBoxContainer/NumKeypad.set_input_node($VBoxContainer/TextEdit)
	$VBoxContainer/NumKeypad.set_notify($".")

func change_sizes(val):
	$VBoxContainer/bar_1.custom_minimum_size.y = 48 + val
	$VBoxContainer/bar_1/bar_1_prog.size.y = 48 + val
	$VBoxContainer/bar_1/bar_1_txt.position.y = 1 + val/2
	$VBoxContainer/bar_1/bar_1_button.size.y = 48 + val
	$VBoxContainer/bar_1/bar_1_button/bar1_touch.shape.size.y = 48 + val
	$VBoxContainer/bar_1/bar_1_button/bar1_touch.position.y = (48 + val)/2
	
	$VBoxContainer/bar_2.custom_minimum_size.y = 48 + val
	$VBoxContainer/bar_2/bar_2_prog.size.y = 48 + val
	$VBoxContainer/bar_2/bar_2_txt.position.y = (1 + val)/2
	$VBoxContainer/bar_2/bar_2_button.size.y = 48 + val
	$VBoxContainer/bar_2/bar_2_button/bar2_touch.shape.size.y = 48 + val
	$VBoxContainer/bar_2/bar_2_button/bar2_touch.position.y = (48 + val)/2
	
	$VBoxContainer/bar_3.custom_minimum_size.y = 48 + val
	$VBoxContainer/bar_3/bar_3_prog.size.y = 48 + val
	$VBoxContainer/bar_3/bar_3_txt.position.y = 1 + val/2
	$VBoxContainer/bar_3/bar_3_button.size.y = 48 + val
	$VBoxContainer/bar_3/bar_3_button/bar3_touch.shape.size.y = 48 + val
	$VBoxContainer/bar_3/bar_3_button/bar3_touch.position.y = (48 + val)/2

	$VBoxContainer/bar_4.custom_minimum_size.y = 48 + val
	$VBoxContainer/bar_4/bar_4_prog.size.y = 48 + val
	$VBoxContainer/bar_4/bar_4_txt.position.y = 1 + val/2
	$VBoxContainer/bar_4/bar_4_button.size.y = 48 + val
	$VBoxContainer/bar_4/bar_4_button/bar4_touch.shape.size.y = 48 + val
	$VBoxContainer/bar_4/bar_4_button/bar4_touch.position.y = (48 + val)/2

	$VBoxContainer/bar_5.custom_minimum_size.y = 48 + val
	$VBoxContainer/bar_5/bar_5_prog.size.y = 48 + val
	$VBoxContainer/bar_5/bar_5_txt.position.y = 1 + val/2
	$VBoxContainer/bar_5/bar_5_button.size.y = 48 + val
	$VBoxContainer/bar_5/bar_5_button/bar5_touch.shape.size.y = 48 + val
	$VBoxContainer/bar_5/bar_5_button/bar5_touch.position.y = (48 + val)/2

func ignore_filter(val):
	if val:
		$VBoxContainer/bar_1/bar_1_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/bar_2/bar_2_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/bar_3/bar_3_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/bar_4/bar_4_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/bar_5/bar_5_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/ultimate_bar/ultimate_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$VBoxContainer/bar_1/bar_1_button/bar1_touch.position.x = 1000
		$VBoxContainer/bar_2/bar_2_button/bar2_touch.position.x = 1000
		$VBoxContainer/bar_3/bar_3_button/bar3_touch.position.x = 1000
		$VBoxContainer/bar_4/bar_4_button/bar4_touch.position.x = 1000
		$VBoxContainer/bar_5/bar_5_button/bar5_touch.position.x = 1000
		$VBoxContainer/ultimate_bar/ultimate_button/ult_touch.position.x = 1000
		$VBoxContainer/Text_display/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		$VBoxContainer/bar_1/bar_1_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/bar_2/bar_2_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/bar_3/bar_3_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/bar_4/bar_4_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/bar_5/bar_5_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/ultimate_bar/ultimate_button.mouse_filter = Control.MOUSE_FILTER_STOP
		$VBoxContainer/bar_1/bar_1_button/bar1_touch.position.x = 206.5
		$VBoxContainer/bar_2/bar_2_button/bar2_touch.position.x = 206.5
		$VBoxContainer/bar_3/bar_3_button/bar3_touch.position.x = 206.5
		$VBoxContainer/bar_4/bar_4_button/bar4_touch.position.x = 206.5
		$VBoxContainer/bar_5/bar_5_button/bar5_touch.position.x = 206.5
		$VBoxContainer/ultimate_bar/ultimate_button/ult_touch.position.x = 206.5
		$VBoxContainer/Text_display/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_STOP

func update_prog():
	skill_1.value = Global.attack1t
	skill_1.max_value = Global.attack1_max_t
	
	skill_2.value = Global.attack2t
	skill_2.max_value = Global.attack2_max_t
	
	skill_3.value = Global.attack3t
	skill_3.max_value = Global.attack3_max_t
	
	skill_4.value = Global.attack4t
	skill_4.max_value = Global.attack4_max_t
	
	skill_5.value = Global.attack5t
	skill_5.max_value = Global.attack5_max_t
	
	ultimate.value = Global.ultimate_charge
	ultimate.max_value = 1000

func _physics_process(_delta: float) -> void:
	update_prog()
	if Global.ultimate_charge == 1000:
		$VBoxContainer/ultimate_bar/ultimate_prog.texture_progress = ultimate_complete
		$VBoxContainer/ultimate_bar/ultimate_5_txt.visible = true
	else: 
		$VBoxContainer/ultimate_bar/ultimate_prog.texture_progress = ultimate_load
		$VBoxContainer/ultimate_bar/ultimate_5_txt.visible = false

func display_attack_text(attack):
	var label = $VBoxContainer/Text_display/RichTextLabel
	var descriptions = $"../../PlayerBody/Class_Actions".get_description()
	
	label.text = descriptions[attack][0]
	for i in range(1, len(descriptions[attack])):
		label.text += descriptions[attack][i]

## unhides and updates the position of newly unlocked attacks
func unhide_attacks():
	if Global.player_attacks >= 2:
		$VBoxContainer/bar_2.visible = true
		if Global.player_attacks >= 3:
			$VBoxContainer/bar_3.visible = true
			if Global.player_attacks >= 4:
				$VBoxContainer/bar_4.visible = true
				if Global.player_attacks >= 5:
					$VBoxContainer/bar_5.visible = true
	if Global.ultimate_attack == 1:
		$VBoxContainer/ultimate_bar.visible = true

func _on_bar_1_button_mouse_entered() -> void:
	display_attack_text("attack_1")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)

func _on_bar_2_button_mouse_entered() -> void:
	display_attack_text("attack_2")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)

func _on_bar_3_button_mouse_entered() -> void:
	display_attack_text("attack_3")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)

func _on_bar_4_button_mouse_entered() -> void:
	display_attack_text("attack_4")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)

func _on_bar_5_button_mouse_entered() -> void:
	display_attack_text("attack_5")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)

func _on_ultimate_button_mouse_entered() -> void:
	display_attack_text("ultimate")
	$VBoxContainer/Text_display/RichTextLabel.scroll_to_line(0)


func _on_bar_1_button_button_down() -> void:
	Input.action_press("attack 1")

func _on_bar_1_button_button_up() -> void:
	Input.action_release("attack 1")

func _on_bar_2_button_button_down() -> void:
	Input.action_press("attack 2")

func _on_bar_2_button_button_up() -> void:
	Input.action_release("attack 2")

func _on_bar_3_button_button_down() -> void:
	Input.action_press("attack 3")

func _on_bar_3_button_button_up() -> void:
	Input.action_release("attack 3")

func _on_bar_4_button_button_down() -> void:
	Input.action_press("attack 4")

func _on_bar_4_button_button_up() -> void:
	Input.action_release("attack 4")

func _on_bar_5_button_button_down() -> void:
	Input.action_press("attack 5")

func _on_bar_5_button_button_up() -> void:
	Input.action_release("attack 5")

func _on_ultimate_button_button_down() -> void:
	Input.action_press("ultimate")

func _on_ultimate_button_button_up() -> void:
	Input.action_release("ultimate")

func keypad_input():
	if $VBoxContainer/TextEdit.text.is_valid_int():
		if int($VBoxContainer/TextEdit.text) > 128:
			change_sizes(128)
		elif int($VBoxContainer/TextEdit.text) >= 0:
			change_sizes(int($VBoxContainer/TextEdit.text))

func _on_button_pressed() -> void:
	if $VBoxContainer/NumKeypad.visible == true:
		$VBoxContainer/NumKeypad.visible = false
	else:
		$VBoxContainer/NumKeypad.visible = true
