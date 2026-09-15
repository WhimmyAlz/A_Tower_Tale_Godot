extends enemyBase

var thorn_preload = preload("res://Scenes/Bosses/Merchant/thorn.tscn")

var stats_offset = Vector2(-200, -60)

@onready var animation = $MerchantSprite

func set_description():
	description = "[b]El Trut or something[/b]\nLevel: %d\n\n[i]\"Erm Ackually..\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA typical Nerd. Hopefully he doesn't try to talk to me.\n\nDrops:\n100%% 20-30 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(_anim):
	# move (he doesn't move)
	animation.play("idle")

func thorn():
	var shock_thorn = thorn_preload.instantiate()
	shock_thorn.set_pos(position + Vector2(220, -35))
	shock_thorn.set_damage(Damage)
	get_tree().current_scene.get_node("Projectiles").add_child(shock_thorn)

func on_death():
	player.gain_xp(randi_range(20, 30))

	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 1000 + (level * 10)
		Max_Health = 1000 + (level * 10)
		Damage = 10 + (level * 0.1)
		Defense_pen = 10
		Speed = 0
		phase = 0
		attackt_start = 110
		phases = {0: [50, 0], 1: [0, 1]}
		update_hp_bar()
	
	set_description()
	update_display_name("Merchant")
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	if attackt >= 0 and attackt <= 119:
		if stunnedf == 0:
			move(animation)
			attackt += 1
		else:
			animation.play("idle")
			animation.pause()
			stunnedf -= 1
		
	elif attackt >= 120 and attackt <= 170:
		if attackt == 120:
			animation.play("attack")
		
		if attackt == 160:
			thorn()

		if attackt >= 162 and attackt <= 166 and attackt % 2 == 0 and randi_range(0, 1) == 1:
			thorn()
	
		attackt += 1
	if attackt >= 170:
		attackt = 0

	take_all_status_effects()
	check_phase()
	spawn_frames()
	friction()
	vert_velocities()
	move_and_slide()
	if mouse_over:
		update_description()

func update_description():
	set_description()
	$EnemyStatsList.set_text(description)
	$EnemyStatsList.fix_pos(direction)

func _on_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
