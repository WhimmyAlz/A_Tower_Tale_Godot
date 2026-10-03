extends enemyBase
var stats_offset = Vector2(170, -60)

@onready var undead_warrior_sprite = $UndeadWarriorSprite
var hitnum = 0
var bonus_hit_speed = 0


func set_description():
	description = "[b]Undead Warrior[/b]\nLevel: %d\n\n[i]\"Let me axe you a question...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nAnother long dead adventurer. Enrages after reaching half health.\n\nDrops:\n12-18 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	animation.speed_scale = Speed * 0.15
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) > 200:
		animation.play("walk")
		self.position.x += Speed * direction
	else:
		animation.play("idle")

	set_direction(self, player)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(12, 18))
		check_class_misc()
	death_rewards = 0
	queue_free()

func attacking():
	var colliders = $Attack_area.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable") and hitnum == 1:
			collider.take_damage(Damage, Defense_pen)
			collider.take_knockback(11, direction)
			collider.take_stun(40)
			hitnum = 0

func check_phase():
	if phases[phase][1] > 0:
		
		if phase == 2:
			attackt = -1
			scale += Vector2(0.0025, 0.0025)
			undead_warrior_sprite.play("idle")

		if phases[phase][1] == 1:
			# check if enemy is "passive" before damaged
			if phase == 1:
				attackt = attackt_start
				if boss_bar != null:
					boss_bar.visible = true
			if phase == 2:
				scale = Vector2(1.2, 1.2)
				bonus_hit_speed = 60
				Damage *= 1.25
				Speed = 13
				attackt = 0

		phases[phase][1] -= 1

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 220 + (level * 45)
		Max_Health = 220 + (level * 45)
		Defense = 2
		Speed = 10
		Damage = 22 + (level * 1.5)

	Name = "Undead Warrior"
	phases = {0: [100, 0], 1: [50, 1], 2 : [0, 80]}
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
	
	if attackt >= 0 and attackt <= 149:
		if stunnedf == 0:
			move($UndeadWarriorSprite)
			attackt += 1
		else:
			undead_warrior_sprite.play("idle")
			undead_warrior_sprite.pause()
			stunnedf -= 1
		
	elif attackt >= 150 and attackt <= 210:

		if attackt == 151:
			undead_warrior_sprite.speed_scale = 1.5
			set_direction(self, player)
			face_player(undead_warrior_sprite)
			$UndeadWarriorSprite.play("attack")
			$Attack_area.position.x = direction * 190
		
		if attackt == 190:
			hitnum = 1
		
		if hitnum == 1:
			attacking()

		attackt += 1
	if attackt >= 210:
		hitnum = 0
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
