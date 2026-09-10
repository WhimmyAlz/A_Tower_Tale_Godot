extends enemyBase

var attackt = -1
var bounce_cd = 60
var stats_offset = Vector2(-200, -150)

var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")

@onready var animation = $SirBlobSprite

func init_boss_bar():
	boss_bar = boss_bar_preload.instantiate()
	boss_bar.visible = false
	boss_bar.update_name("[b]SIR BLOB[/b]")
	get_tree().current_scene.get_node("Boss_Health_Bars").get_node("boss_hp_container").add_child(boss_bar)

func update_hp_bar():
	$HealthBar.update_value(Health)
	$HealthBar.update_max_value(Max_Health)
	boss_bar.update_value(Health)
	boss_bar.update_max_value(Max_Health)

func set_description():
	description = "[b]SIR BLOB[/b]\nLevel: %d\n\n[i]\"...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription: Some say this is what happens when you leave an orange in a fridge for too long.\n\nDrops:\n50-90 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(_anim):
	# move
	if direction == -1:
		self.position.x -= Speed
		animation.play("walk")
	elif direction == 1:
		self.position.x += Speed
		animation.play("walk")
	else:
		animation.play("idle")

	# flip
	if direction == 1:
		animation.flip_h = false
	elif direction == -1:
		animation.flip_h = true
	
	if randi_range(1,60) == 1:
		direction = randi_range(-1,1)

func init_attack():
	if direction == 0:
		if randi_range(0,1) == 1:
			direction = 1
		else:
			direction = -1

	stunnedf = 0
	velocity.x = direction * 1000
	$Area2D.visible = true
	self.remove_from_group("attackable")
	$Area2D/CollisionShape2D.disabled = false

func attack():
	var collisions = $Area2D.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("walls") and bounce_cd == 0:
			direction *= -1
			velocity.x = direction * 1000
			bounce_cd = 30
	
	$Area2D.rotation += Speed * 0.02 * direction
	
	if bounce_cd > 0:
		bounce_cd -= 1
	
	if self.is_on_floor():
		player.get_parent().set_screenshake(10)
		self.velocity.y = -2500

func deactivate_attack():
	$Area2D.visible = false
	self.add_to_group("attackable")
	$Area2D/CollisionShape2D.disabled = true

func on_death():
	boss_bar.queue_free()
	player.gain_xp(randi_range(50, 90))
	
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 1000 + (level * 100)
		Max_Health = 1000 + (level * 100)
		Damage = 45 + (level * 5)
		Speed = 3

		init_boss_bar()
		update_hp_bar()

	set_description()
	update_display_name("Sir Blob")
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(2.8)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -200)

func take_stun(stun_time):
	if attackt == -1:
		attackt = 0
		boss_bar.visible = true
	if shock_stacks == 0 or stunnedf == 0: 
		stunnedf = stun_time
	else:
		stunnedf += int(stun_time * (shock_stacks/100))

func _physics_process(_delta: float) -> void:
	if attackt >= 0 and attackt <= 179:
		if stunnedf == 0:
			move(animation)
			attackt += 1
		else:
			animation.play("idle")
			animation.pause()
			stunnedf -= 1
	elif attackt == -1 and stunnedf == 0:
		move(animation)
		
	if attackt >= 180 and attackt <= 690:
		if attackt == 180:
			self.velocity.y = -3000

		if attackt == 200:
			init_attack()
		attack()
		
		attackt += 1
	else:
		friction()

	if attackt >= 690:
		deactivate_attack()
		attackt = 0
	
	take_all_status_effects()
	
	spawn_frames()
	vert_velocities()
	move_and_slide()
	
	if mouse_over:
		update_description()

func update_description():
	set_description()
	$EnemyStatsList.set_text(description)
	if direction == 0:
		$EnemyStatsList.fix_pos(1)
	else:
		$EnemyStatsList.fix_pos(direction)

func _on_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	var collider = body
	
	var kb_dir

	if collider.is_in_group("player") and collider.is_in_group("attackable"):
		if collider.position.x > position.x:
			kb_dir = 1
		else:
			kb_dir = -1
		
		collider.take_damage(Damage, Defense_pen)
		collider.take_knockback(30, kb_dir)
		collider.take_stun(30)
