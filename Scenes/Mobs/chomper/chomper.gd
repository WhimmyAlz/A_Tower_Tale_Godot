extends enemyBase
var stats_offset = Vector2(170, -5)

@onready var chomper_sprite = $ChomperSprite
var bonus_hit_speed = 0

func set_description():
	description = "[b]Chomper[/b]\nLevel: %d\n\n[i]\"...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nThat friend that asks for a bite.\n\nDrops:\n12-18 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	face_player(chomper_sprite)
	set_direction(self, player)
	if animation == 1:
		$ChomperSprite.modulate.a = (31-float(attackt))/30
	else:
		$ChomperSprite.modulate.a =  float(attackt-130)/20
	if self.is_on_floor():
		if abs(self.position.x - player.position.x) > 10:
			self.position.x -= Speed * direction * animation
		chomper_sprite.play("walk")
	else:
		chomper_sprite.play("idle")

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(12, 18))
	death_rewards = 0
	queue_free()

func attacking():
	var colliders = $Attack_area.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable"):
			collider.take_damage(Damage, Defense_pen)
			collider.take_knockback(1, direction)
			collider.take_stun(5)

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 350 + (level * 50)
		Max_Health = 350 + (level * 50)
		Defense = 1
		Speed = 7
		Damage = 40 + (level * 4)
		Name = "Chomper"
		
	update_hp_bar()
	$HealthBar.set_name_size(22)
	
	set_description()

	update_display_name(Name)
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -50)

func _physics_process(_delta: float) -> void:
	
	if attackt >= 0 and attackt <= 200:
		if stunnedf == 0:
			if attackt >= 0 and attackt <= 30:
				move(1)
			if attackt == 30:
				self.visible = false
				self.remove_from_group("attackable")
			
			if attackt == 130:
				self.visible = true
				self.add_to_group("attackable")
				if abs(player.position.x + (200 * direction)) > 1000:
					direction *= -1
				self.position = player.position + Vector2(200 * direction, 0)
		
			if attackt >= 130 and attackt <= 150:
				move(-1)
			
			if attackt == 151:
				$ChomperSprite.modulate.a = 1
				$ChomperSprite.play("attack")
			
			if attackt == 171:
				attacking()
			
			attackt += 1
		else:
			chomper_sprite.play("idle")
			chomper_sprite.pause()
			stunnedf -= 1
			attackt = 0

	if attackt >= 181:
		attackt = bonus_hit_speed

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
