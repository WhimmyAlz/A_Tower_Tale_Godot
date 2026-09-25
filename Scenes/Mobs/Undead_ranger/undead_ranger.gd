extends enemyBase

var arrow = preload("res://Scenes/Mobs/Undead_ranger/arrow.tscn")

var stats_offset = Vector2(170, -50)

@onready var undead_ranger_animation = $UndeadRangerSprite

func set_description():
	description = "[b]Undead Ranger[/b]\nLevel: %d\n\n[i]\"I was once an adventurer like you...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA long dead adventurer.. Incredibly weak to stuns.\n\nDrops:\n10-20 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	undead_ranger_animation = animation
	animation.play("idle")
	face_player(animation)
	set_direction(self, player)

func shoot():
	var projectile = arrow.instantiate()
	projectile.set_pos(position + Vector2(60, -35))
	projectile.set_damage(Damage)
	projectile.set_direction(direction)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func on_death():
	player.gain_xp(randi_range(10, 20))
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 120 + (level * 35)
		Max_Health = 120 + (level * 35)
		Defense = 0
		Speed = 0
		Damage = 30 + (level * 2)
		Name = "Undead Ranger"
		
	update_hp_bar()
	$HealthBar.set_name_size(18)
	
	set_description()

	update_display_name(Name)
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	
	if attackt >= 0 and attackt <= 199:
		if stunnedf == 0:
			move($UndeadRangerSprite)
			attackt += 1
		else:
			undead_ranger_animation.play("idle")
			undead_ranger_animation.pause()
			stunnedf -= 1
			attackt = 0
		
	elif attackt >= 200 and attackt <= 265:
		if stunnedf != 0:
			attackt = 0
		if attackt == 201:
			set_direction(self, player)
			face_player(undead_ranger_animation)
			$UndeadRangerSprite.play("attack")
		
		if attackt == 240:
			shoot()
	
		attackt += 1
	if attackt >= 265:
		if stunnedf == 0:
			$UndeadRangerSprite.frame = 0
			attackt = 170
		else:
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
	$EnemyStatsList.fix_pos()

func _on_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
