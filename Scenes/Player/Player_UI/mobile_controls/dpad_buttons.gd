extends Node2D

func _on_e_button_button_down() -> void:
	Input.action_press("interact")

func _on_e_button_button_up() -> void:
	Input.action_release("interact")



func _on_q_button_button_down() -> void:
	Input.action_press("inventory")

func _on_q_button_button_up() -> void:
	Input.action_release("inventory")


func _on_dpad_up_pressed() -> void:
	Input.action_press("up")


func _on_dpad_up_released() -> void:
	Input.action_release("up")


func _on_dpad_down_pressed() -> void:
	Input.action_press("down")


func _on_dpad_down_released() -> void:
	Input.action_release("down")


func _on_dpad_left_pressed() -> void:
	Input.action_press("left")


func _on_dpad_left_released() -> void:
	Input.action_release("left")


func _on_dpad_right_pressed() -> void:
	Input.action_press("right")


func _on_dpad_right_released() -> void:
	Input.action_release("right")
