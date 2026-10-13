extends Node


#// pls help buttons
func _on_pls_help_button_pressed() -> void:
	var button_container = $pls_help_button/pls_help_buttons
	if button_container.visible:
		button_container.visible = false
	else:
		button_container.visible = true

func _on_skill_issue_button_pressed() -> void:
	for i in range(25):
		var enemy = preload("res://Scenes/Mobs/gray_bird/gray_bird.tscn").instantiate()
		enemy.set_pos(Vector2(randi_range(-1000,1000), 300))
		enemy.Level = int(1000)
		get_tree().current_scene.get_node("Enemies").add_child(enemy)

#//
