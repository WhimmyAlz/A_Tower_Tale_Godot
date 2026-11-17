extends Node2D

func _on_e_button_button_down() -> void:
	Input.action_press("interact")

func _on_e_button_button_up() -> void:
	Input.action_release("interact")



func _on_q_button_button_down() -> void:
	Input.action_press("inventory")

func _on_q_button_button_up() -> void:
	Input.action_release("inventory")
