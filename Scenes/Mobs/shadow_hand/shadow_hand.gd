extends enemyBase
var stats_offset = Vector2(170, -60)

@onready var hand_sprite = $handSprite

func set_description():
	description = "[b]Shadow Hand[/b]\nLevel: %d\n\n[i]\"They call me: The Hand That Feeds You. Pls don't bite.\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\n[Insert joke I've been waiting really long to make here]\n\nDrops:\n%d-%d xp" % [Level, Health, Damage, Defense, Defense_pen, xp_range[0], xp_range[1]]

func set_pos(pos):
	position = pos

func move(animation):
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) > 200:
		animation.play("walk")
		self.position.x += Speed * direction
	else:
		animation.play("idle")

	set_direction(self, player)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(xp_range[0], xp_range[1]))
		check_class_misc()
	death_rewards = 0
	queue_free()

func attacking():
	var colliders = $Attack_area.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable"):
			collider.take_damage(Damage, Defense_pen)
			collider.take_knockback(2, direction)
			collider.take_stun(30)

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		xp_range = [6, 10]
		Health = 200 + (level * 20)
		Max_Health = 200 + (level * 20)
		Defense = 1
		Speed = 12
		Damage = 30 + (level * 2)

		Name = "Shadow Hand"
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
	if attackt >= 0 and attackt <= 49:
		if stunnedf == 0:
			move(hand_sprite)
			attackt += 1
		else:
			$handSprite.play("idle")
			stunnedf -= 1
		
	elif attackt >= 50 and attackt <= 90:
		attackt += 1
		
		if attackt == 51:
			$handSprite.speed_scale = 1.5
			set_direction(self, player)
			face_player(hand_sprite)
			$handSprite.play("attack")
			$Attack_area.position.x = direction * 75
		
		if attackt == 80:
			attacking()
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

func _on_stats_collider_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true
	update_description()

func _on_stats_collider_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
