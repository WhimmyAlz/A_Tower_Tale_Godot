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
		enemy.Level = int(5318008)
		enemy.Damage = 1
		enemy.Max_Health = 1
		enemy.Health = 1
		enemy.scale = Vector2(1.5, 1.5)
		enemy.Name = "Get permastunned lol"
		enemy.death_rewards = 0
		enemy.xp_range = [0, 0]
		get_tree().current_scene.get_node("Enemies").add_child(enemy)

func _on_instructions_button_pressed() -> void:
	if $"../Instructions".visible == true:
		$"../Instructions".visible = false
	else:
		$"../Instructions".visible = true
		$"../Instructions".position = Vector2(-1600, 500)
		$"../Instructions".scale = Vector2(1, 1)

#// enemy guide button
func _on_enemy_guide_button_pressed() -> void:
	if $"../Enemy_guide".visible == true:
		$"../Enemy_guide".visible = false
	else:
		$"../Enemy_guide".visible = true
		$"../Enemy_guide".position = Vector2(-1300, 150)
		$"../Enemy_guide".scale = Vector2(1, 1)
