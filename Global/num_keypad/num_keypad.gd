extends Node2D

var input_node
var notify = false
var notify_node

func set_notify(val):
	notify_node = val
	notify = true

func notify_text():
	if notify:
		notify_node.keypad_input()

func set_input_node(val):
	input_node = val
	notify_text()

func _on_num_1_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "1"
	notify_text()

func _on_num_2_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "2"
	notify_text()

func _on_num_3_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "3"
	notify_text()

func _on_num_4_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "4"
	notify_text()

func _on_num_5_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "5"
	notify_text()

func _on_num_6_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "6"
	notify_text()

func _on_num_7_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "7"
	notify_text()

func _on_num_8_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "8"
	notify_text()

func _on_num_9_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "9"
	notify_text()

func _on_num_0_button_up() -> void:
	if len(input_node.text) < 10:
		input_node.text += "0"
	notify_text()

func _on_del_pressed() -> void:
	input_node.text = input_node.text.substr(0, len(input_node.text)-1)
	notify_text()

func _on_cc_button_up() -> void:
	input_node.text = ""
	notify_text()
