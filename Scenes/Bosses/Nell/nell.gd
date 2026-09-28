extends enemyBase

var arrow = preload("res://Scenes/Bosses/Nell/fire_arrow.tscn")

var stats_offset = Vector2(170, -70)
var shots = 0
var dodge_cd = 0
@onready var nell_animation = $NellSprite

func set_description():
	description = "[b]Nell[/b]\nLevel: %d\n\n[i]\"I was once an adventurer like you...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA long dead adventurer.. Incredibly weak to stuns.\n\nDrops:\n10-16 xp" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) < 1200:
		if abs(self.position.x - player.position.x) < 200 and dodge_cd == 0:
			dodge()
			dodge_cd = 600
		elif abs(self.position.x - player.position.x) < 1200:
			animation.play("walk")
			self.position.x -= Speed * direction
	else:
		animation.play("idle")
	set_direction(self, player)

func dodge():
	var enemy_list
	var closest_enemy = null
	enemy_list = get_tree().current_scene.get_node("Enemies")
	if enemy_list.get_child_count() > 0:
		closest_enemy = enemy_list.get_child(0)
		for i in range(enemy_list.get_child_count()):
			if enemy_list.get_child(i) != self and abs(enemy_list.get_child(i).position.x - position.x) < abs(closest_enemy.position.x - position.x):
				closest_enemy = enemy_list.get_child(i)
		closest_enemy.velocity.x = 2 * (player.position.x - closest_enemy.position.x)
		velocity.x = direction * 2500
func shoot():
	var projectile = arrow.instantiate()
	projectile.set_pos(position + Vector2(direction * 60, -35))
	projectile.set_damage(Damage)
	projectile.set_direction(direction)
	projectile.set_defense_pen(Defense_pen)
	projectile.get_shooter(self)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(10, 16))
	death_rewards = 0
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 600 + (level * 35)
		Max_Health = 600 + (level * 35)
		Defense = 2
		Speed = 4
		Damage = 10 + (level * 1)
		Defense_pen = 5
		Name = "Nell"
		
	update_hp_bar()
	
	set_description()

	update_display_name(Name)
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	if dodge_cd > 0:
		dodge_cd -= 1
	if attackt >= 0 and attackt <= 199:
		if attackt == 0:
			shots = 0
		if stunnedf == 0:
			move($NellSprite)
			attackt += 1
		else:
			nell_animation.play("idle")
			nell_animation.pause()
			stunnedf -= 1
			attackt = 0
		
	elif attackt >= 200 and attackt <= 265:
		if stunnedf != 0:
			attackt = 0
		if attackt == 201:
			set_direction(self, player)
			face_player(nell_animation)
			$NellSprite.play("attack")
		
		if attackt == 220:
			shots += 1
			shoot()
	
		attackt += 1
	if attackt >= 265:
		if stunnedf == 0 and shots < 3:
			$NellSprite.frame = 0
			attackt = 199
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
