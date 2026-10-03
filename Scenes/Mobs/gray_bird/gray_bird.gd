extends enemyBase
var stats_offset = Vector2(170, -60)

@onready var gray_bird_sprite = $GrayBirdSprite
var hitnum = 0
var attack = 2
var momentum = 0

func set_description():
	description = "[b]Gray Bird[/b]\nLevel: %d\n\n[i]\"Why are my legs so messed up?\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\n\"Sorry i'm bad at drawing legs\" -Developer\n\nDrops:\n15-25 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	animation.speed_scale = momentum * 0.25
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) > 400:
		animation.play("walk")
		momentum += Speed * direction * 0.1
	else:
		animation.play("idle")

	set_direction(self, player)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(15, 25))
		check_class_misc()
	death_rewards = 0
	queue_free()

func attacking():
	var colliders = $Attack_area.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable") and hitnum >= 1:
			if attack == 2:
				collider.take_damage(Damage * 0.5, Defense_pen)
			else:
				collider.take_damage(Damage, Defense_pen)
			if hitnum == 1:
				collider.take_knockback(10, direction)
			collider.take_stun(40)
			hitnum -= 1

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 180 + (level * 40)
		Max_Health = 180 + (level * 40)
		Defense = 8
		Speed = 8
		Damage = 30 + (level * 1.5)

	Name = "Gray Bird"
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
	self.position.x += momentum
	momentum *= 0.95
	if attackt >= 0 and attackt <= 49:
		if stunnedf == 0:
			move($GrayBirdSprite)
			if abs(self.position.x - player.position.x) < 400:
				attackt += 1
		else:
			gray_bird_sprite.play("idle")
			gray_bird_sprite.pause()
			stunnedf -= 1
		
	elif attackt >= 50 and attackt <= 90:

		if attackt == 51:
			attack = randi_range(1,2)
			gray_bird_sprite.speed_scale = 1.5
			set_direction(self, player)
			face_player(gray_bird_sprite)
			if attack == 2:
				$GrayBirdSprite.play("attack_2")
			else:
				$GrayBirdSprite.play("attack_1")
			$Attack_area.position.x = direction * 150
		
		if (attackt == 60 and attack == 2) or (attack == 1 and attackt == 70):
			hitnum = 1
			if attack == 2:
				hitnum = 3
		
		if hitnum > 0 and ((attack == 2 and attackt % 9 == 0) or attack == 1):
			attacking()

		attackt += 1
	if (attack == 1 and attackt >= 74) or (attack == 2 and attackt >= 90):
		hitnum = 0
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
